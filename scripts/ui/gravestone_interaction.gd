extends InteractionArea


@export var gravestone_description : PackedScene
var screen = null

func _on_activated():
	if(is_instance_valid(screen)):
		screen.queue_free()
		GlobalUtilities.player.unfreeze()
	else:
		screen = gravestone_description.instantiate()
		GlobalUtilities.player.freeze()
		GlobalUtilities.level_handler.add_child(screen)
