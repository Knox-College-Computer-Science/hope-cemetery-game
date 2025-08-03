extends InteractionArea

@export var file_path : String
## Name of the spawn point where you want the player to start.
## Leave it blank for the player to start in the default position for the scene.
@export var spawn_point : String


func _on_activated():
	GlobalUtilities.level_handler.switch_scene_with_spawn_point(load(file_path), spawn_point)
