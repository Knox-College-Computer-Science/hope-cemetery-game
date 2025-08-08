extends Node2D

var tween : Tween = null
@onready var label = $VBoxContainer/PanelContainer/TextContainer/Label
@export var popup_area : InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	skew = -PI/2
	show()
	if(is_instance_valid(popup_area)):
		popup_area.activated.connect(popup)
		popup_area.exited.connect(popdown)
	"""await get_tree().create_timer(1).timeout
	popup()
	await get_tree().create_timer(4).timeout
	popdown()"""

func popup():
	label.visible_ratio = 0
	if(is_instance_valid(tween)):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "skew", 0.0, 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "visible_ratio", 1, 2)

func popdown():
	if(is_instance_valid(tween)):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "skew", -PI/2, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
