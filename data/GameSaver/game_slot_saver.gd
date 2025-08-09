extends Node

"""
TODO (-) = Not done, (+) = Done
+ make get_metadata(slot: int) function (also access by string?)
+ dialogic saving in slots?
+ Allow for storing metadata (via resources) that applies to whole game save
+ Save files should be seperated some how. Load level saves according
  to save files
+ Also seperate autoloads into slots
+ player spawn points
+ link node references in variables
+ automatically save all data if no save function is found


NEEDED TO USE GAMESLOTSAVER:
	- game_slot_saver.gd
	- "saveable" global group
	- saved_level.gd
	- save_addon.gd

RECOMMENDED COMPONENTS:
	- save_screen scene

WHEN TO USE THIS SYSTEM:
	This system was made for games with a leveled architecture.
	Save data is stored relative to the root node of each scene
	representing a level.

SAVING LEVELS:
	Make sure the world_scene variable is pointing to the root of the
	current level. Then call the save_level function.

TO SAVE A SCENE:
	1. Put it into the "saveable" group 
	3. That's it! This scene and all of its properties
	   will be automatically saved when you call save_level.
	   You can give your scene an "on_load" function if
	   you need to prepare things before the scene is 
	   reinstantiated into the world. You can also optionally
	   add a "save" function, which returns a list of strings
	   that corrispond to variable names that should be saved.
	   Use this if you only want to save a select few properties.

WHAT ABOUT CHILD NODES?
	This is where things can get complicated. In order to make sure
	that a child node is reparented with the correct node, we must
	distinguish between two types of children:
		1. Children that are a part of the scene when it is instantiated
		2. Children that are added at runtime or are added to the root 
		   within the context of another scene.
		   (e.g. the player getting a unique camera for each level)

	- First type
		These are nodes that are with their parent automatically
		when the parent is initialized. To save their attributes,
		use the format "child_name$attribute_name" when returning
		the save list for the parent. For nested children, this
		would look like "child_one$child_two$attribute_name"
		
		NOTE: If you want to save the deletion of these nodes,
		you will likely need to make a seperate attribute for this
		and then delete the child inside the on_load function.

	- Second type
		These nodes can be in the saveable group, just like their parent.

		TIP: If you need to know whether a scene is being instantiated
		for the first time or being loaded from a save file, you can
		make a boolean variable that is set when the on_load function is
		called. Then check that variable's value in the _on_ready function
		or whereever else you may need that information.
	
MAINTAINING NODE REFERENCES
1. Make sure that the reference you are saving points to an
   object that is also being saved. (Use the save_addon if needed.)
2. Add a variable called "saved_node_references". This should hold
   a list of the names of variables that have node references.
   NOTE: Data structures holding multiple references are currently
   not supported.
"""

const SAVE_DIRECTORY = "user://save"
const TEMPORARY_SAVE_DATA_PATH = SAVE_DIRECTORY+"/temp"
const AUTOLOAD_SAVE_PATH = TEMPORARY_SAVE_DATA_PATH+"/autoload_save_data.tres"
const SAVE_ADDON_PATH = "res://data/GameSaver/save_addon.gd"

## Scene to be saved/loaded when save_level or load_level are called.
@export var world_scene : Node
## Autoload singletons to be saved. Enter their name as they appear in the scene tree.
@export var autoloads_to_save : Array[String]
@export var screenshot_viewport : Node

var slot_names = ["Slot 1", "Slot 2", "Slot 3"]
var meta_keys = ["scene_file_path", "$index", "$parent_index", "$autoload", "owner"]
var child_delimiter = "$"
var reference_key_name = "saved_node_references"

## Saves the scene stored in world_scene variable
func save_level():
	var saved_level = SavedLevel.new()
	var saveable_scenes = get_saveable_nodes(world_scene)
	
	# Add items and their attributes to SavedLevel resource
	var ind = 0
	var scene_array = []
	for i in saveable_scenes:
		var data = {"scene_file_path":i.scene_file_path, "$index":ind}
		if(!is_instance_valid(i.get_script())):
			if(!is_instance_valid(load(SAVE_ADDON_PATH))):
				push_error("SAVE_ADDON_PATH is likely incorrect! It should give the correct
				path to the save_addon.gd script.")
			i.set_script(load(SAVE_ADDON_PATH))
			i.class_of_object = i.get_class()
		if(has_property(i, reference_key_name)):
			data[reference_key_name] = i.get(reference_key_name)
		if !i.has_method("save"): 
			for attr in i.get_property_list():
				data[attr["name"]] = get_node_attr_value(attr["name"], i)
		elif i.has_method("save") && i.save() != null:
			for attr in i.save():
				if(get_node_attr_value(attr, i) == null):
					push_warning(attr+" in "+i.name+" is equal to null! It might not exist as an attribute!")
				data[attr] = get_node_attr_value(attr, i)
		saved_level.item_states.append(data)
		scene_array.append(i)
		ind += 1
	
	ind = 0
	for i in scene_array:
		# Link children and parents
		var parent_index
		if(i.get_parent() == world_scene):
			parent_index = -1
		else:
			parent_index = saveable_scenes.find(i.get_parent())
		saved_level.item_states[ind]["$parent_index"] = parent_index
		
		# Link nodes references by index
		if(has_property(i, reference_key_name)):
			for prop in i.get(reference_key_name):
				if(is_instance_valid(i.get(prop))):
					saved_level.item_states[ind][prop] = saveable_scenes.find(i.get(prop))
				else:
					saved_level.item_states[ind][prop] = -1
		ind += 1

	# Save resources
	if(!DirAccess.dir_exists_absolute(TEMPORARY_SAVE_DATA_PATH)):
		DirAccess.make_dir_recursive_absolute(TEMPORARY_SAVE_DATA_PATH)
	ResourceSaver.save(saved_level, TEMPORARY_SAVE_DATA_PATH+"/"+get_file_name(world_scene)+".tres")

## Loads the scene stored in world_scene variable. (Remember to set world_scene
## beforehand!)
func load_level():
	var saved_level = load(TEMPORARY_SAVE_DATA_PATH+"/"+get_file_name(world_scene)+".tres")
	if(!is_instance_valid(saved_level)):
		return
		
	# Reset map
	delete_saveable_nodes(world_scene)
	
	# Create instanes of new scenes, set their properties, and add them to 
	# scene_array
	var scene_array = []
	var new_scene
	for item in saved_level.item_states:
		# Instantiate saved node
		if(item["scene_file_path"] != ""):
			new_scene = load(item["scene_file_path"]).instantiate()
		else:
			new_scene = ClassDB.instantiate(item["class_of_object"])
			new_scene.set("script", item["script"])
		
		# Set node properties
		var set_position = false
		for key in item:
			if(not key in meta_keys or (reference_key_name in item.keys() and key in item[reference_key_name])):
				if(key == "position" || key == "global_position"):
					if(set_position):
						continue
					else:
						set_position = true
				get_final_child(key, new_scene).set(get_node_attr(key), item[key])
		
		if(new_scene.has_method("on_load")):
			new_scene.on_load()
		new_scene.add_to_group("saveable")
		scene_array.append(new_scene)
	
	if(world_scene.has_method("on_load")):
		world_scene.on_load()
	
	# Add children nodes to parents and link node references
	for item in saved_level.item_states:
		var node = scene_array[item["$index"]]
		
		# references
		if(reference_key_name in item.keys()):
			for prop in node.get(reference_key_name):
				if(int(item[prop]) != -1):
					node.set(prop, scene_array[int(item[prop])])
		
		# parenting
		if(item["$parent_index"] == -1):
			world_scene.add_child(node)
		else:
			var parent_node = scene_array[item["$parent_index"]]
			parent_node.add_child(node)

## Save autoloads named in autoloads_to_save array
func save_autoloads(dialogic_slot = ""):
	var saved_autoloads = SavedLevel.new()
	for autoload in autoloads_to_save:
		var data = {"$autoload": autoload}
		for p in get_node("/root/"+autoload).get_property_list():
			data[p["name"]] = get_node("/root/"+autoload).get(p["name"])
		saved_autoloads.item_states.append(data)
	ResourceSaver.save(saved_autoloads, AUTOLOAD_SAVE_PATH)
	Dialogic.Save.save(dialogic_slot, false, Dialogic.Save.ThumbnailMode.NONE)

## Load autoloads named in autoloads_to_save array
func load_autoloads(dialogic_slot = ""):
	var saved_autoloads = load(AUTOLOAD_SAVE_PATH)
	if(!is_instance_valid(saved_autoloads)):
		return
	for al in saved_autoloads.item_states:
		for property in al:
			if(not property in meta_keys):
				get_node("/root/"+al["$autoload"]).set(property, al[property])
	Dialogic.Save.load(dialogic_slot)

## Put all of the saved levels into a common folder, specified by slot number
func save_game(slot: int, metadata: SaveMetadata = null):
	if(slot > slot_names.size()):
		push_error("Trying to save to invalid slot!")
		return
		
	save_image()
	save_autoloads(slot_names[slot])
	
	# Save metadata
	if(!is_instance_valid(metadata)):
		var new_data = SaveMetadata.new()
		ResourceSaver.save(new_data, TEMPORARY_SAVE_DATA_PATH+"/metadata.tres")
	else:
		ResourceSaver.save(metadata, TEMPORARY_SAVE_DATA_PATH+"/metadata.tres")
	
	# Clear slot that data is being moved to
	clear_slot(slot)
	
	# Put data from temp into slot
	if(!DirAccess.dir_exists_absolute(SAVE_DIRECTORY+"/"+slot_names[slot])):
		DirAccess.make_dir_recursive_absolute(SAVE_DIRECTORY+"/"+slot_names[slot])
	for file in DirAccess.get_files_at(TEMPORARY_SAVE_DATA_PATH):
		DirAccess.copy_absolute(TEMPORARY_SAVE_DATA_PATH+"/"+file, SAVE_DIRECTORY+"/"+slot_names[slot]+"/"+file)
		#print_debug("Saving file "+file+" to "+slot_names[slot]+". Path: "+SAVE_DIRECTORY+"/"+slot_names[slot]+"/"+file)

## Load saved levels from slot
func load_game(slot: int):
	clear_temp()
	if(slot > slot_names.size()):
		push_error("Trying to load from invalid slot!")
		return
	for file in DirAccess.get_files_at(SAVE_DIRECTORY+"/"+slot_names[slot]):
		DirAccess.copy_absolute(SAVE_DIRECTORY+"/"+slot_names[slot]+"/"+file, TEMPORARY_SAVE_DATA_PATH+"/"+file)
		#print_debug("Loading file "+file+" from slot "+str(slot))
	load_autoloads(slot_names[slot])

## Gets save file metadata from a particular slot
func get_save_metadata(slot: int):
	var meta : SaveMetadata = load(SAVE_DIRECTORY+"/"+slot_names[slot]+"/metadata.tres")
	return meta

## Extract attribute value from child chain
func get_node_attr_value(attr : String, parent : Node):
	if(not child_delimiter in attr):
		return parent.get(attr)
	
	var child_node = get_final_child(attr, parent)
	var attribute = get_node_attr(attr)
	return child_node.get(attribute)

## Extract attribute name from child chain
func get_node_attr(attr : String):
	var nodes = attr.split(child_delimiter)
	return nodes.get(nodes.size()-1)

## Get the child whose attribute is being changed
func get_final_child(attr : String, parent : Node):
	if(not child_delimiter in attr):
		return parent
		
	var nodes = attr.split(child_delimiter)
	nodes.remove_at(nodes.size()-1)
	var child_node = parent
	for node in nodes:
		child_node = child_node.find_child(node)
	return child_node

func get_file_name(node):
	return node.scene_file_path.split(".tscn")[0].split("/")[-1]

## Clear all save data
func clear_all():
	clear_path(SAVE_DIRECTORY)

## Clear save data for this session
func clear_temp():
	clear_path(TEMPORARY_SAVE_DATA_PATH)

## Clear save data stored at the specified path
func clear_path(path: String):
	var files = DirAccess.get_files_at(path)
	for file in files:
		DirAccess.remove_absolute(path+"/"+file)
	for dir in DirAccess.get_directories_at(path):
		clear_path(path+"/"+dir)

## Clear save data stored a specific slot
func clear_slot(slot: int):
	clear_path(SAVE_DIRECTORY+"/"+slot_names[slot])

## Check if a node has a particular property
func has_property(node, property):
	var properties = node.get_property_list()
	var property_names = []
	for prop in properties:
		property_names.append(prop["name"])
	return property in property_names

## Get all nodes in the "saveable" group
func get_saveable_nodes(node) -> Array[Node]:
	var children : Array = node.get_children().duplicate()
	var saveable_children : Array[Node] = []
	for child in children:
		if(child.is_in_group("saveable")):
			saveable_children.append(child)
		saveable_children.append_array(get_saveable_nodes(child))
	return saveable_children

## Delete all of the nodes in the "saveable" group
func delete_saveable_nodes(node):
	var saveable_nodes = get_saveable_nodes(node)
	for n in saveable_nodes:
		n.get_parent().remove_child(n)
		n.queue_free()

## Generate image from subviewport
func save_image():
	if(!is_instance_valid(screenshot_viewport)):
		return
	var capture = screenshot_viewport.get_texture().get_image()
	var filename = TEMPORARY_SAVE_DATA_PATH+"/screenshot.png"
	capture.save_png(filename)
	

func _on_clear_pressed():
	clear_all()
