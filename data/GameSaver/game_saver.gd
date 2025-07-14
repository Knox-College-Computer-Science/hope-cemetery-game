extends Node

"""
NEEDED TO USE GAMESAVER:
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
	use the format "child_name.attribute_name" when returning
	the save list for the parent. For nested children, this
	would look like "child_one.child_two.attribute_name"
	
	NOTE: If you want to save the deletion of these nodes,
	you will likely need to make a seperate attribute for this
	and then delete the child inside the on_load function.

- Dynamically added
	These nodes are added to the parent at runtime. These nodes can
	be in the saveable group and return their own list of attributes
	when the save function is called on them, just like their parent.
	Note that the child must be its own scene and the child's parent
	must also be saveable.
"""
 

@export var world_scene : Node

var meta_keys = ["scene_file_path", "$index", "$parent_index"]
var child_delimiter = "////"

func save_game():
	#var saved_game : Pudding = Pudding.new()
	#ResourceSaver.save(Pudding, "user://saved.tres")

	
	var saved_game = SavedGame.new()
	var saveable_scenes = get_tree().get_nodes_in_group("saveable")
	
	# Add items and their attributes to SavedGame resource
	var ind = 0
	var scene_array = []
	for i in saveable_scenes:
		var data = {"scene_file_path":i.scene_file_path, "$index":ind}
		if i.has_method("save") && i.save() == null:
			ind += 1
			continue
		if i.has_method("save"):
			for attr in i.save():
				if(get_node_attr_value(attr, i) == null):
					push_warning(attr+" in "+i.name+" is equal to null! It might not exist as an attribute!")
				data[attr] = get_node_attr_value(attr, i)
		saved_game.item_states.append(data)
		scene_array.append(i)
		ind += 1
	
	print(saved_game.item_states)
	
	# Link children and parents
	ind = 0
	for i in scene_array:
		var parent_index
		if(i.get_parent() == world_scene):
			parent_index = -1
		else:
			parent_index = saveable_scenes.find(i.get_parent())
		saved_game.item_states[ind]["$parent_index"] = parent_index
		ind += 1
	
	
	# Save resources
	ResourceSaver.save(saved_game, "user://saved.tres")
	Dialogic.Save.save("", false, Dialogic.Save.ThumbnailMode.NONE)
	

func load_game():
	var saved_game = load("user://saved.tres")
	get_tree().call_group("saveable", "queue_free")
	var scene_array = []
	var new_scene
	for item in saved_game.item_states:
		if(item["scene_file_path"] != ""):
			new_scene = load(item["scene_file_path"]).instantiate()
		else:
			print("New class instantiated: "+item["class_of_object"])
			new_scene = ClassDB.instantiate(item["class_of_object"])
		
		for key in item:
			if(not key in meta_keys):
				print("set "+get_node_attr(key)+" as "+str(item[key]))
				get_final_child(key, new_scene).set(get_node_attr(key), item[key])
		if(new_scene.has_method("on_load")):
			new_scene.on_load()
		new_scene.add_to_group("saveable")
		scene_array.append(new_scene)
	
	# Add children nodes to parents
	for item in saved_game.item_states:
		var node = scene_array[item["$index"]]
		if(item["$parent_index"] == -1):
			world_scene.add_child(node)
		else:
			var parent_node = scene_array[item["$parent_index"]]
			parent_node.add_child(node)
			
	Dialogic.Save.load()

func get_node_attr_value(attr : String, parent : Node):
	if(not "." in attr):
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
