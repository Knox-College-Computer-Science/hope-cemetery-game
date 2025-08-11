extends RigidBody2D
class_name PhysicsHomeworkBlock

func get_collision_shape():
	return $CollisionShape2D

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
