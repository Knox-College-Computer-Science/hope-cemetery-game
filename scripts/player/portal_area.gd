extends Area2D

@export var file_path : String
@export var automatic : bool = true

var is_inside = false

func _on_area_entered(area):
	#get_tree().change_scene_to_file(file_path)
	if(automatic):
		GlobalUtilities.level_handler.switch_scene_by_path(file_path)
	else:
		is_inside = true


func _on_area_exited(area):
	is_inside = false
	
func _process(delta):
	if(Input.is_action_just_pressed("interact") && is_inside):
		GlobalUtilities.level_handler.switch_scene_by_path(file_path)
