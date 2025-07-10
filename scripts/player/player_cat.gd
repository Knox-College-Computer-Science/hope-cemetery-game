extends CharacterBody2D

@export var move_speed: float = 100
@export var startDir: Vector2 = Vector2(0,1)
@onready var animTree: AnimationTree = $AnimationTree
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@onready var sprite = $Sprite2D
@onready var cemetary_music = $"../cemetary_music"
@onready var dorm = $"../Alex/room music"
@onready var footsteps_sfx = $footstep
@onready var timer = $Timer
func _ready():
	update_animation_parameters(startDir)
	#$"../Alex/room music".play()
	
func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	update_animation_parameters(input_direction)
	
	if(Dialogic.current_timeline == null):
		velocity = input_direction * move_speed
	else:
		velocity = Vector2.ZERO
		
	pick_new_state()
	move_and_slide()
	
	# This snaps the sprite position into the pixel grid
	sprite.global_position = global_position.round()

func update_animation_parameters(move_input : Vector2):
	if(move_input.x < 0):
		sprite.flip_h = true
	elif(move_input.x > 0):
		sprite.flip_h = false
	if(move_input != Vector2.ZERO):
		animTree.set("parameters/Walk/blend_position", move_input)
		animTree.set("parameters/Idle/blend_position", move_input)
	else:
		animTree.set("parameters/Walk/blend_position", Vector2.ZERO)
		animTree.set("parameters/Idle/blend_position", Vector2.ZERO)

func pick_new_state():
	if (!velocity.is_equal_approx(Vector2.ZERO)):
		stateMachine.travel("Walk")
		if !footsteps_sfx.playing:
			footsteps_sfx.play()
			timer.start()
	else:
		stateMachine.travel("Idle")
		if footsteps_sfx.playing:
			footsteps_sfx.stop()
			timer.stop()


func _on_timer_timeout() -> void:
	footsteps_sfx.play()
	timer.start()
