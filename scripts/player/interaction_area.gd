extends Area2D
class_name InteractionArea

## If true, automatically fires the activated signal when area is entered
@export var automatic = false
@export var show_prompt = true
var is_inside = false
var activated_since_entering = false

signal activated
signal entered
signal exited

func _ready():
	set_collision_layer_value(2, true)
	set_collision_mask_value(2, false)

func enter():
	is_inside = true
	entered.emit()
	if(automatic):
		activate()

func exit():
	activated_since_entering = false
	is_inside = false
	exited.emit()

func activate():
	activated_since_entering = true
	activated.emit()
