extends InteractionArea

"""
Basic NPC character that doesn't move but can be talked to. Requires an
AnimatedSprite2D or Sprite2D to be added as a child and referenced in the
animation_player export variable. Also remember to add a collision shape
as a child of this node, or else it won't be able to sense the player!
To move and animate this character in a pre-scripted fashion, 
see choreographed_npc.tscn.
"""

## Sprite2D or AnimatedSprite2D that is being used to visualize this character.
@export var animation_player : Node2D
@export var default_animation : String = "default"
## Conversation that starts when the player interacts with this npc deliberately
@export var timeline : String
@export var show_npc_prompt : bool = true
@export var prompt_height : float
## If true, the character will not be able to interact with this npc.
@export var disabled : bool
@export_category("Immediate Interaction")
## If true, this npc will start a timeline as soon as the player hits the interaction area
@export var interact_immediately : bool
## If the player enters this area, the timeline specified will start
@export var immediate_interaction_area : InteractionArea
## Dialogue timeline to play when player enters area
@export var immediate_timeline : String

var is_touching_player = false
var has_just_been_talked_to = false
var already_had_immediate_encounter = false
var additional_prompt_height = 0
var saved_node_references = ["immediate_interaction_area", "animation_player"]

@onready var interact_prompt = $InteractPrompt

func _ready():
	super()
	Dialogic.timeline_ended.connect(cooldown)
	if(animation_player is AnimatedSprite2D && default_animation != ""):
		animation_player.play(default_animation)
	if(interact_immediately && immediate_timeline != "" && is_instance_valid(immediate_interaction_area)):
		immediate_interaction_area.show_prompt = false
		immediate_interaction_area.automatic = true
		immediate_interaction_area.entered.connect(play_dialogue)
	
	# Set height of interact prompt  
	interact_prompt.global_position.y += prompt_height

func _on_activated():
	if(Dialogic.current_timeline == null && !has_just_been_talked_to && !disabled):
		interact_prompt.hide()
		Dialogic.start(timeline)
		has_just_been_talked_to = true

func switch_animation(new_animation):
	animation_player.play(new_animation)

func face_right(dir: bool):
	animation_player.flip_h = !dir

func _on_area_entered(area):
	pass

func _on_area_exited(area):
	pass

func cooldown():
	if(has_just_been_talked_to):
		$CoolDownTimer.start()

func _on_cool_down_timer_timeout():
	has_just_been_talked_to = false

func play_dialogue():
	if(!already_had_immediate_encounter && !disabled):
		already_had_immediate_encounter = true
		Dialogic.start(immediate_timeline)

func _on_entered():
	if(show_npc_prompt && !has_just_been_talked_to && !disabled):
		interact_prompt.show()

func _on_exited():
	interact_prompt.hide()
