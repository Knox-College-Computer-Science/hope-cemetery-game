extends Node2D

var tween : Tween = null
@onready var label = $VBoxContainer/PanelContainer/TextContainer/Label
@export var popup_area : InteractionArea
@export var disabled = false

func _ready():
	skew = -PI/2
	reset_text()
	show()
	if(is_instance_valid(popup_area)):
		popup_area.activated.connect(popup)
		popup_area.exited.connect(popdown)

func popup():
	if(!disabled):
		if(is_instance_valid(tween)):
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property(self, "skew", 0.0, 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(label, "visible_ratio", 1, 2*(1-label.visible_ratio))

func popdown():
	if(is_instance_valid(tween)):
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "skew", -PI/2, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.finished.connect(reset_text)
	
func reset_text():
	label.visible_ratio = 0
	
