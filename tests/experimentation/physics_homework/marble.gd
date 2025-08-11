extends RigidBody2D

var reset = false
var reset_position : Vector2

func _ready():
	reset_position = position

func _integrate_forces(state):
	if(reset):
		var t = state.get_transform()
		t.origin.x = reset_position.x
		t.origin.y = reset_position.y
		state.set_transform(t)
		reset = false
