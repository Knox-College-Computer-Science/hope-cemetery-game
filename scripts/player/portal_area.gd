extends Area2D

@export var file_path : String
@export var automatic : bool = true
## Name of the spawn point where you want the player to start.
## Leave it blank for the player to start in the defualt position for the scene.
@export var spawn_point : String

var is_inside = false

func _on_area_entered(area):
	#get_tree().change_scene_to_file(file_path)
	if(automatic):
		GlobalUtilities.level_handler.switch_scene_with_spawn_point(load(file_path), spawn_point)
	else:
		is_inside = true

func _on_area_exited(area):
	is_inside = false
	
func _process(delta):
	if(Input.is_action_just_pressed("interact") && is_inside):
		GlobalUtilities.level_handler.switch_scene_with_spawn_point(load(file_path), spawn_point)
