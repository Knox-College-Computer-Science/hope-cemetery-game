extends Node

"""
TO-DO
- player spawn points
+ link node references in variables
+ automatically save all data if no save function is found


NEEDED TO USE GAMELEVELSAVER:
	- game_saver.gd
	- "saveable" global group
	- saved_game.gd

TO SAVE A SCENE:
	(NOTE: must be it's own scene)
	1. Put it into the "saveable" group 
	2. Give it a method called "save". This should return
	   a list of strings that give the names of the properties
	   you want to save. (e.g. return ["position", "modulate"])
	   If you want GameSaver to ignore a scene with the save
	   function, just return null instead of an array.
	3. That's it! You can give your scene an "on_load" function if
	   you need to prepare things before the scene is 
	   reinstantiated into the world.
	
WHAT ABOUT CHILD SCENES?
This is where things can get complicated. In order to make sure
that a child node is reparented with the correct node, we must
distinguish between dynamically added children and statically
added children. Depending on what kind of children you are dealing
with, there are different workflows you should take.

- Statically added
	These are nodes that are with their parent automatically
	when the parent is initialized. To set their attributes,
	use the format "child_name$attribute_name" when returning
	the save list for the parent. For nested children, this
	would look like "child_one$child_two$attribute_name"
	
	NOTE: If you want to save the deletion of these nodes,
	you will likely need to make a seperate attribute for this
	and then delete the child inside the on_load function.

- Dynamically added
	These nodes are added to the parent at runtime. These nodes can
	be in the saveable group and return their own list of attributes
	when the save function is called on them, just like their parent.
	Note that the child must be its own scene and the child's parent
	must also be saveable. Alternatively, you can add the save_addon.gd
	script to the node if it has no script.
	
MAINTAINING NODE REFERENCES
1. Make sure that the reference you are saving points to an
   object that is also being saved. (Use the save_addon if needed.)
2. Add a variable called "saved_node_references". This should hold
   a list of the names of variables that have node references.
"""
 
const AUTOLOAD_SAVE_PATH = "user://autoload_save_data.tres"
@export var world_scene : Node
@export var autoloads_to_save : Array[String]
var meta_keys = ["scene_file_path", "$index", "$parent_index", "$autoload", "owner"]
var child_delimiter = "$"
var reference_key_name = "saved_node_references"
var save_addon_path = "res://data/GameSaver/save_addon.gd"

func save_level():
	var saved_game = SavedGame.new()
	var saveable_scenes = get_tree().get_nodes_in_group("saveable")
	
	# Add items and their attributes to SavedGame resource
	var ind = 0
	var scene_array = []
	for i in saveable_scenes:
		var data = {"scene_file_path":i.scene_file_path, "$index":ind}
		if(!is_instance_valid(i.get_script())):
			i.set_script(load(save_addon_path))
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
		saved_game.item_states.append(data)
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
		saved_game.item_states[ind]["$parent_index"] = parent_index
		
		# Link nodes references by index
		if(has_property(i, reference_key_name)):
			for prop in i.get(reference_key_name):
				if(is_instance_valid(i.get(prop))):
					saved_game.item_states[ind][prop] = saveable_scenes.find(i.get(prop))
				else:
					saved_game.item_states[ind][prop] = -1
		ind += 1

	# Save resources
	ResourceSaver.save(saved_game, "user://"+get_file_name(world_scene)+".tres")

func load_level(player_position: bool = false):
	var saved_game = load("user://"+get_file_name(world_scene)+".tres")
	if(!is_instance_valid(saved_game)):
		return
	get_tree().call_group("saveable", "queue_free")
	var scene_array = []
	var new_scene
	for item in saved_game.item_states:
		if(item["scene_file_path"] != ""):
			new_scene = load(item["scene_file_path"]).instantiate()
		else:
			new_scene = ClassDB.instantiate(item["class_of_object"])
			new_scene.set("script", item["script"])
		
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
	
	# Add children nodes to parents and link node references
	for item in saved_game.item_states:
		var node = scene_array[item["$index"]]
		
		#references
		if(reference_key_name in item.keys()):
			for prop in node.get(reference_key_name):
				node.set(prop, scene_array[item[prop]])
		
		# parenting
		if(item["$parent_index"] == -1):
			world_scene.add_child(node)
		else:
			var parent_node = scene_array[item["$parent_index"]]
			parent_node.add_child(node)
		
	
func save_autoloads():
	var saved_autoloads = SavedGame.new()
	for autoload in autoloads_to_save:
		var data = {"$autoload": autoload}
		for p in get_node("/root/"+autoload).get_property_list():
			data[p["name"]] = get_node("/root/"+autoload).get(p["name"])
		saved_autoloads.item_states.append(data)
	ResourceSaver.save(saved_autoloads, AUTOLOAD_SAVE_PATH)
	Dialogic.Save.save("", false, Dialogic.Save.ThumbnailMode.NONE)
	
func load_autoloads():
	var saved_autoloads = load(AUTOLOAD_SAVE_PATH)
	if(!is_instance_valid(saved_autoloads)):
		return
	for al in saved_autoloads.item_states:
		for property in al:
			if(not property in meta_keys):
				get_node("/root/"+al["$autoload"]).set(property, al[property])
	Dialogic.Save.load()

func get_node_attr_value(attr : String, parent : Node):
	if(not child_delimiter in attr):
		return parent.get(attr)
	
	var child_node = get_final_child(attr, parent)
	var attribute = get_node_attr(attr)
	return child_node.get(attribute)

func get_node_attr(attr : String):
	var nodes = attr.split(child_delimiter)
	return nodes.get(nodes.size()-1)
	
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

func clear():
	var files = DirAccess.get_files_at("user://")
	for file in files:
		DirAccess.remove_absolute("user://"+file)

func has_property(node, property):
	var properties = node.get_property_list()
	var property_names = []
	for prop in properties:
		property_names.append(prop["name"])
	return property in property_names

func _on_save_pressed():
	save_level()

func _on_load_pressed():
	load_level()
	
func _on_clear_pressed():
	clear()
