extends CanvasLayer

var mouse_pressed = false
var mouse_disabled = false
var original_marble_position : Vector2
var snapshots = []

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
			

func _unhandled_input(event):
	if event is InputEventMouseButton && event.is_pressed():
		if(!mouse_pressed && !mouse_disabled):
			"""var b = RigidBody2D.new()
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
			b.add_to_group("shapes")"""
			var b = load("res://tests/experimentation/block.tscn").instantiate()
			b.position = get_viewport().get_mouse_position()
			save_snapshot()
			add_child(b)
		mouse_pressed = true
	else:
		mouse_pressed = false


func _on_submit_pressed():
	if(mouse_disabled):
		reset_marble()
		undo()
	else:
		save_snapshot()
		$Marble.gravity_scale = 1
		$Marble.collision_layer = 3
		$Marble.collision_mask = 1
		$SubmitButton.text = "Try Again"
	mouse_disabled = !mouse_disabled
	$UndoButton.disabled = mouse_disabled
	

func _on_area_2d_body_entered(body):
	$TextureRect.hide()
	

func _on_reset_pressed():
	get_tree().call_group("shapes", "queue_free")
	reset_marble()
	snapshots.clear()
	mouse_disabled = false


func reset_marble():
	$Marble.set_deferred("linear_velocity", Vector2.ZERO)
	$Marble.reset = true
	$Marble.gravity_scale = 0
	$Marble.collision_layer = 0
	$Marble.collision_mask = 0
	$SubmitButton.text = "Submit answer"

func save_snapshot():
	var new_snapshot = []
	for child in get_children():
		if(child is PhysicsHomeworkBlock):
			var new_item = {}
			new_item["position"] = child.position
			new_item["rotation"] = child.rotation
			new_item["linear_vel"] = child.linear_velocity
			new_item["angular_vel"] = child.angular_velocity
			new_snapshot.append(new_item)
	snapshots.append(new_snapshot)

func _on_undo_button_pressed():
	undo()
	
func undo():
	if(snapshots.is_empty()):
		return
	get_tree().call_group("shapes", "queue_free")
	for item in snapshots[-1]:
		var b = load("res://tests/experimentation/block.tscn").instantiate()
		b.position = item["position"]
		b.rotation = item["rotation"]
		b.linear_velocity = item["linear_vel"]
		b.angular_velocity = item["angular_vel"]
		add_child(b)
	snapshots.pop_back()
