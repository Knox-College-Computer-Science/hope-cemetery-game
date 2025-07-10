extends CharacterBody2D

@export var speed = 200
@onready var space = $"../../CanvasLayer4"
var player_in_range: bool = false

func _ready():
	space.visible = false
func get_input():
	var input_direction = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
	if player_in_range and Input.is_action_just_pressed("talk"):
		glob_quest.love_letter_active = true
		print(glob_quest.love_letter_active)



func _on_quest_vision_sample_body_entered(body):
	print("entered")
	space.visible = true
	player_in_range = true
	


func _on_quest_vision_sample_body_exited(body):
	print("exited")
	space.visible = false
	player_in_range = false
