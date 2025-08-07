extends InteractionArea

@export var save_description = ""

func _on_activated():
	GlobalUtilities.level_handler.toggle_save_screen(save_description)
