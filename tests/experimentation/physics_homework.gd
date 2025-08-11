extends CanvasLayer

var mouse_pressed = false
var mouse_disabled = false
var original_marble_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	original_marble_position = $Marble.position
	for child in get_children():
		if(child is StaticBody2D):
			var col_shape = child.get_children()[0]
			var mesh_in = MeshInstance2D.new()
			var box_mesh = BoxMesh.new()
			box_mesh.size = Vector3(col_shape.shape.size.x, col_shape.shape.size.y, 0)
			mesh_in.mesh = box_mesh
			#mesh_in.global_position = col_shape.global_position
			col_shape.add_child(mesh_in)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		if(!mouse_pressed && !mouse_disabled):
			var b = RigidBody2D.new()
			var col = CollisionShape2D.new()
			var sh := RectangleShape2D.new()
			var v = VisibleOnScreenNotifier2D.new()
			var mesh_in = MeshInstance2D.new()
			var box_mesh = BoxMesh.new()
			box_mesh.size = Vector3(40, 40, 0)
			mesh_in.mesh = box_mesh
			v.screen_exited.connect(b.queue_free)
			sh.size = Vector2(40, 40)
			col.shape = sh
			b.add_child(col)
			b.add_child(mesh_in)
			b.position = get_viewport().get_mouse_position()
			b.add_child(v)
			b.add_to_group("shapes")
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
	

func _on_button_2_pressed():
	get_tree().call_group("shapes", "queue_free")
	$Marble.set_deferred("linear_velocity", Vector2.ZERO)
	#$Marble.transform.origin = original_marble_position
	$Marble.reset = true
	$Marble.gravity_scale = 0
	$Marble.collision_layer = 0
	$Marble.collision_mask = 0
	mouse_disabled = false
