extends Area2D

@export var file_path : String

func _on_area_entered(area):
	#get_tree().change_scene_to_file(file_path)
	GlobalUtilities.level_handler.switch_scene_by_path(file_path)
