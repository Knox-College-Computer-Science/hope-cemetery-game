extends Node

## 🎵 No one likes the opening band...
@export var opening_scene : PackedScene
@onready var game_saver = $GameSaver

const DEFAULT_BUS_PATH = "res://audio/default_bus_layout.tres"
var current_scene : Node

func _ready():
	GlobalUtilities.level_handler = self
	game_saver.clear()
	game_saver.load_autoloads()
	switch_scene(opening_scene)

func get_new_level_instance(scene : PackedScene):
	AudioServer.set_bus_layout(load(DEFAULT_BUS_PATH))
	if(is_instance_valid(current_scene)):
		game_saver.save_level() # Need to be able to specify level
		remove_child(current_scene)
		current_scene.queue_free()
	var new_scene = scene.instantiate()
	game_saver.world_scene = new_scene
	game_saver.save_autoloads()
	return new_scene
	

## Switch scene without loading save data
func switch_scene(scene : PackedScene):
	AudioServer.set_bus_layout(load(DEFAULT_BUS_PATH))
	if(is_instance_valid(current_scene)):
		game_saver.save_level() # Need to be able to specify level
		remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	game_saver.world_scene = current_scene
	game_saver.save_autoloads()
	
## Switch scene and load save data
func switch_and_load_scene(scene : PackedScene):
	switch_scene(scene)
	game_saver.load_level()

## Switch scene by path without loading save data
func switch_scene_by_path(path : String):
	var scene = load(path)
	switch_scene(scene)

## Switch scene by path and load save data
func switch_and_load_scene_by_path(path : String):
	var scene = load(path)
	switch_and_load_scene(scene)

func switch_scene_with_spawn_point(scene : PackedScene, spawn_pt : String):
	var new_level = get_new_level_instance(scene)
	var original_player = get_player(new_level)
	#"""
	print("new scene: "+new_level.name)
	print("original position: "+str(original_player.position))
	#await get_tree().create_timer(2).timeout
	game_saver.load_level()
	print("position after load: "+str(get_player(new_level).position))
	#await get_tree().create_timer(2).timeout
	if(spawn_pt == ""):
		print("empty spawn point")
		get_player(new_level).position = original_player.position
	else:
		print("spawn point named "+spawn_pt)
		var points = get_nodes_in_group(new_level, "spawn_point")
		var point_found = false
		for p in points:
			print("point: "+p.spawn_point_name)
			if(p.spawn_point_name == spawn_pt):
				get_player(new_level).position = p.position
				point_found = true
				print_debug(p.position)
				print_debug(get_player(new_level).position)
		if(!point_found):
			print("Spawn point "+spawn_pt+" does not exist!")
			push_error("Spawn point "+spawn_pt+" does not exist!")
	#switch_scene(new_level)
	#"""
	game_saver.save_level()
	current_scene = new_level
	add_child(new_level)

func get_player(node):
	var children : Array = node.get_children().duplicate()
	for child in children:
		if(child.is_in_group("player")):
			print("player name: "+child.name)
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
