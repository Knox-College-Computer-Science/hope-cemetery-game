extends CharacterBody2D

@export var move_speed: float = 100
@export var startDir: Vector2 = Vector2(0,1)
@onready var animTree: AnimationTree = $AnimationTree
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@onready var sprite = $Sprite2D
@onready var footsteps_sfx = $footstep
@onready var timer = $Timer

var input_disabled

func _ready():
	GlobalUtilities.player = self
	update_animation_parameters(startDir)
	#$"../Alex/room music".play()

func on_load():
	GlobalUtilities.player = self
	
func _physics_process(_delta):
	if(input_disabled):
		return
	
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
	
	# Handle interactions
	if(Input.is_action_just_pressed("interact")):
		activate_interactive_areas()
	var areas_inside = false
	for area in $InteractionArea.get_overlapping_areas():
		if(area is InteractionArea && area.show_prompt && !area.activated_since_entering):
			areas_inside = true
	$InteractionPrompt.visible = areas_inside

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

func save():
	return ["position"]

func _on_interaction_area_area_entered(area):
	if(area is InteractionArea):
		area.enter()

func _on_interaction_area_area_exited(area):
	if(area is InteractionArea):
		area.exit()

func activate_interactive_areas():
	for area in $InteractionArea.get_overlapping_areas():
		if(area is InteractionArea):
			area.activate()
