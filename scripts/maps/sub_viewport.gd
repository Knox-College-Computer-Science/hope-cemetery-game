extends SubViewport
@export var camera_node : Node2D
@export var player_node : Node2D
var minimap_marker : Node2D

func _ready() -> void:
	world_2d = get_tree().root.world_2d
