extends Node2D

@export var player : CharacterBody2D
var saved_node_references = ["player"]


func _on_interaction_area_activated():
	player.input_disabled = true
	var t := get_tree().create_tween()
	t.tween_property(player, "position", global_position + Vector2(0, -200), 3).set_trans(Tween.TRANS_CIRC)
	t.finished.connect(GlobalUtilities.level_handler.fade_out.bind(Color(1,1,1,1), 4))
