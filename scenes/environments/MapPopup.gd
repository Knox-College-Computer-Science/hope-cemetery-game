extends PopupPanel

signal area_chosen(String)

func _ready() -> void:
	hide()  # ensure hidden

	# Bind the string directly, not as a one-element Array:
	$Zones/OldMain.pressed.connect(
		Callable(self, "_on_zone").bind("OldMain")
	)
	
	$Zones/Post.pressed.connect(
		Callable(self, "_on_zone").bind("Post")
	)

func _on_zone(area_id: String) -> void:
	emit_signal("area_chosen", area_id)
	hide()
