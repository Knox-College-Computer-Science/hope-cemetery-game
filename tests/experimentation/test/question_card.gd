extends PanelContainer
class_name QuestionCard

@onready var question = $MarginContainer/VBoxContainer/Question
@onready var answer = $MarginContainer/VBoxContainer/HBoxContainer/Panel/Answer
@onready var percent = $MarginContainer/VBoxContainer/HBoxContainer/Percent

var possible_answers = [
	"George Washington", "Abraham Lincoln",
	"Mary Tyler Moore", "Scott Haris",
	"The Holy Bible", "Corruption",
	"Reckless Drivers", "Pony Tails",
	"Table Tennis", "War and Peace"
]
var rotate_tween : Tween = null
var percent_solved = 0
var touching_mouse = false
var words = []

signal selected
signal deselected
signal card_discarded(percent)

# Called when the node enters the scene tree for the first time.
func _ready():
	question.text = ""
	answer.text = possible_answers.pick_random()
	for word in words:
		question.text += "[color=red]" + word + "[/color], "
	
	modulate = Color.TRANSPARENT
	#position.y -= 50
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate", Color.WHITE, 1).set_trans(Tween.TRANS_CIRC)
	#t.parallel().tween_property(self, "position", Vector2(position.x, position.y-50), 1).set_trans(Tween.TRANS_CIRC)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	answer.visible_ratio = percent_solved/100.0
	percent.text = str(percent_solved)+"%"
	if(Input.is_action_just_pressed("interact") && touching_mouse):
		deselect()
		deselected.emit()
		discard_card()


func _on_mouse_entered():
	touching_mouse = true
	if(is_instance_valid(rotate_tween)):
		rotate_tween.kill()
	rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation", PI/16, .2).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)


func _on_mouse_exited():
	touching_mouse = false
	if(is_instance_valid(rotate_tween)):
		rotate_tween.kill()
	rotate_tween = get_tree().create_tween()
	rotate_tween.tween_property(self, "rotation", 0, .2).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	
func _on_button_toggled(toggled_on):
	if(toggled_on):
		modulate = Color.LIME_GREEN
		selected.emit()
	else:
		modulate = Color.WHITE
		deselected.emit()

func deselect():
	$Button.button_pressed = false
	modulate = Color.WHITE

func add_percent(amount):
	if(amount > 0):
		$Particles.emitting = true
	percent_solved = min(percent_solved+amount, 100)
	if(percent_solved >= 100):
		discard_card()

func remove_word(word : String):
	question.text = word.join(Array(question.text.split("[color=red]" + word + "[/color]")))
	words.erase(word)
	
func discard_card():
	if(!is_instance_valid(get_tree())):
		queue_free()
		return
	var t = get_tree().create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, .5).set_trans(Tween.TRANS_CIRC)
	t.parallel().tween_property(self, "position:y", position.y+50, .5).set_trans(Tween.TRANS_CIRC)
	t.finished.connect(queue_free)
	card_discarded.emit(percent_solved)
