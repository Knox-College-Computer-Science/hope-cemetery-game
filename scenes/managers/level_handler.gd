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
	game_saver.load_level()

func switch_scene_by_path(path : String):
	var scene = load(path)
	switch_scene(scene)


	
