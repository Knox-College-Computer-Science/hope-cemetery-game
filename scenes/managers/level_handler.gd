extends Node

## 🎵 No one likes the opening band...
@export var opening_scene : PackedScene

@onready var game_saver = $GameSaver

var current_scene : Node

func _ready():
	switch_scene(opening_scene)
	
func switch_scene(scene : PackedScene):
	if(is_instance_valid(current_scene)):
		game_saver.save_level() # Need to be able to specify level
		remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	game_saver.world_scene = current_scene
	game_saver.load_level()

func switch_scene_by_path(path : String):
	var scene = load(path)
	if(is_instance_valid(current_scene)):
		game_saver.save_level() # Need to be able to specify level
		remove_child(current_scene)
		current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	game_saver.world_scene = current_scene
	game_saver.load_level()

func _on_clear_pressed():
	game_saver.clear()


	
