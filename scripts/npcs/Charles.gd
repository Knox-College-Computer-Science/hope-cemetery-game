extends CharacterBody2D

enum Charles_State {IDLE, WALK}
@export var move_speed: float = 20
@export var idle_time: float = 5
@export var walk_time: float = 2

@onready var animTree: AnimationTree = $AnimationTree
@onready var stateMachine = animTree.get("parameters/playback")
@onready var sprite = $Sprite2D
@onready var timer = $Timer

var move_direction: Vector2 = Vector2.ZERO
var current_state: Charles_State = Charles_State.IDLE


func _ready():
	animTree.active = true
	select_new_direction()
	pick_new_state()

func _physics_process(_delta):
	if(current_state == Charles_State.WALK):
		velocity = move_direction * move_speed
		move_and_slide()

func select_new_direction():
	move_direction = Vector2(
		randi_range(-1,1),
		randi_range(-1,1)
	)

	if(move_direction.x < 0):
		sprite.flip_h = true
	elif(move_direction.x > 0):
		sprite.flip_h = false

func pick_new_state():
	if (current_state == Charles_State.IDLE):
		stateMachine.travel("Walk")
		current_state = Charles_State.WALK
		select_new_direction()
		timer.start(walk_time)
	elif(current_state == Charles_State.WALK):
		stateMachine.travel("Idle")
		current_state = Charles_State.IDLE
		timer.start(idle_time)


func _on_timer_timeout() -> void:
	pick_new_state()
