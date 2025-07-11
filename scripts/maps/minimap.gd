extends CanvasLayer
@export var player : CharacterBody2D
@export var sprite : Sprite2D

@onready var sub_viewport = $SubViewportContainer/SubViewport

var miniMapPlayer : CharacterBody2D

func ready():
	miniMapPlayer = player.duplicate()
	
	sub_viewport.addChild(sprite.duplicate())
	sub_viewport.addChild(miniMapPlayer)
	
