extends Node

## 🎵 No one likes the opening band...
@export var opening_scene : PackedScene
@onready var game_saver = $GameSaver
## The levels are made a child of this node so that screenshots can be taken
@onready var display_node = $SubViewportContainer/SubViewport

const DEFAULT_BUS_PATH = "res://audio/default_bus_layout.tres"
var current_scene : Node

func _ready():
	GlobalUtilities.level_handler = self
	game_saver.clear_temp()
	game_saver.load_autoloads()
	switch_scene(opening_scene, false)

func get_new_level_instance(scene : PackedScene):
	AudioServer.set_bus_layout(load(DEFAULT_BUS_PATH))
	if(is_instance_valid(current_scene)):
		game_saver.save_level()
		remove_child(current_scene)
		current_scene.queue_free()
	var new_scene = scene.instantiate()
	SaveMetaData.current_level_path = new_scene.scene_file_path
	print_debug(SaveMetaData.current_level_path)
	game_saver.world_scene = new_scene
	return new_scene
	

## Switch scene without loading save data
func switch_scene(scene : PackedScene, save_data = true):
	AudioServer.set_bus_layout(load(DEFAULT_BUS_PATH))
	if(is_instance_valid(current_scene)):
		if(save_data):
			game_saver.save_level() 
		remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instantiate()
	SaveMetaData.current_level_path = current_scene.scene_file_path
	print_debug(SaveMetaData.current_level_path)
	display_node.add_child(current_scene)
	game_saver.world_scene = current_scene
	
	
## Switch scene and load save data
func switch_and_load_scene(scene : PackedScene, save_data = true):
	switch_scene(scene, save_data)
	game_saver.load_level()

## Switch scene by path without loading save data
func switch_scene_by_path(path : String, save_data = true):
	var scene = load(path)
	switch_scene(scene, save_data)

## Switch scene by path and load save data
func switch_and_load_scene_by_path(path : String, save_data = true):
	var scene = load(path)
	switch_and_load_scene(scene, save_data)

func switch_scene_with_spawn_point(scene : PackedScene, spawn_pt : String):
	var new_level = get_new_level_instance(scene)
	var original_player = get_player(new_level)
	game_saver.load_level()
	if(spawn_pt == ""):
		get_player(new_level).position = original_player.position
	else:
		var points = get_nodes_in_group(new_level, "spawn_point")
		var point_found = false
		for p in points:
			if(p.spawn_point_name == spawn_pt):
				get_player(new_level).position = p.position
				point_found = true
		if(!point_found):
			print("Spawn point "+spawn_pt+" does not exist!")
			push_error("Spawn point "+spawn_pt+" does not exist!")
	game_saver.save_level()
	current_scene = new_level
	display_node.add_child(new_level)

func get_player(node):
	var children : Array = node.get_children().duplicate()
	for child in children:
		if(child.is_in_group("player")):
			return child
		var player_child = get_player(child)
		if(player_child != null):
			return player_child
	return null

func get_nodes_in_group(node, group) -> Array[Node]:
	var children : Array = node.get_children().duplicate()
	var group_children : Array[Node] = []
	for child in children:
		if(child.is_in_group(group)):
			group_children.append(child)
		group_children.append_array(get_nodes_in_group(child, group))
	return group_children

func toggle_save_screen():
	$SaveScreen.toggle_panel()
