extends Area2D
class_name InteractionArea

## If true, automatically fires the activated signal when area is entered
@export var automatic = false
var is_inside = false

signal activated
signal entered
signal exited

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enter():
	is_inside = true
	entered.emit()

func exit():
	is_inside = false
	exited.emit()

func activate():
	activated.emit()
