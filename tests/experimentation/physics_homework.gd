extends CanvasLayer

var mouse_pressed = false
var mouse_disabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		if(!mouse_pressed && !mouse_disabled):
			var b = RigidBody2D.new()
			var col = CollisionShape2D.new()
			var sh := RectangleShape2D.new()
			var v = VisibleOnScreenNotifier2D.new()
			v.screen_exited.connect(b.queue_free)
			sh.size = Vector2(40, 40)
			col.shape = sh
			b.add_child(col)
			b.position = get_viewport().get_mouse_position()
			b.add_child(v)
			add_child(b)
		mouse_pressed = true
	else:
		mouse_pressed = false


func _on_button_pressed():
	$Marble.gravity_scale = 1
	$Marble.collision_layer = 3
	$Marble.collision_mask = 1
	mouse_disabled = true


func _on_area_2d_body_entered(body):
	$TextureRect.hide()
	
