extends Control

@export var target: CharacterBody2D
@export var map_scale: float = 0.2
@export var minimap_center: Vector2 = Vector2(1180,62)

func _process(delta):
	if target:
		position = minimap_center + target.global_position * map_scale
