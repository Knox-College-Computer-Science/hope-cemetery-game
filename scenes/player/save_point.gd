extends Area2D

@export var save_description = ""
var is_touching_player = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("interact") && is_touching_player):
		GlobalUtilities.level_handler.toggle_save_screen(save_description)


func _on_area_entered(area):
	is_touching_player = true


func _on_area_exited(area):
	is_touching_player = false
