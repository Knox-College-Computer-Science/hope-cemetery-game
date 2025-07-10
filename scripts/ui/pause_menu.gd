extends Control
@onready var pause_canvas = $CanvasLayer
@onready var blur = $ColorRect

func _ready():
	# Start with pause menu hidden
	pause_canvas.visible = false
	blur.visible = false
	blur.mouse_filter = Control.MOUSE_FILTER_IGNORE


func turnbutton():
	blur.visible = !blur.visible
	if pause_canvas.visible == false:
		pause_canvas.visible = true
		blur.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		pause_canvas.visible = false
		blur.mouse_filter = Control.MOUSE_FILTER_IGNORE

func pause():
	turnbutton()


func _on_resume_pressed():
	turnbutton()

func _on_quit_pressed():
	get_tree().quit()

func _on_options_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_save_pressed():
	print("Game saved!")

func _on_sound_control_pressed():
	get_tree().change_scene_to_file("res://sound_options_menu.tscn")

func _on_restart_pressed() -> void:
	pass

func _on_go_to_main_settings_pressed() -> void:
	pass



func _on_settings_pressed() -> void:
	pass


func _on_texture_button_pressed():
	turnbutton()
