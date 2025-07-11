extends CanvasLayer

@onready var alex = $PanelContainer/VBoxContainer/alex
@onready var alex_pop = $PanelContainer/VBoxContainer/alex/alex_popup
@onready var woman = $PanelContainer/VBoxContainer/woman
@onready var woman_pop = $PanelContainer/VBoxContainer/woman/woman_popup
@onready var henry = $PanelContainer/VBoxContainer/henry
@onready var henry_pop = $PanelContainer/VBoxContainer/henry/henry_popup
##Sets all popups under their buttons including a close button
func _on_alex_toggled(toggled_on):
	alex_pop.popup()
	var pos1 = alex.get_global_position() + Vector2(0, alex.size.y)
	alex_pop.set_position(pos1)

func _on_alex_close_pressed():
	alex_pop.hide()

func _on_woman_toggled(toggled_on):
	woman_pop.popup()
	var pos1 = woman.get_global_position() + Vector2(0, woman.size.y)
	woman_pop.set_position(pos1)

func _on_woman_close_pressed():
	woman_pop.hide()

func _on_henry_toggled(toggled_on):
	henry_pop.popup()
	var pos1 = henry.get_global_position() + Vector2(0, henry.size.y)
	henry_pop.set_position(pos1)

func _on_henry_close_pressed():
	henry_pop.hide()

#checks what people should be showing from glob_people
func update_people():
	#should be automated better
	if glob_people.henry:
		henry.visible = true
	if glob_people.woman:
		woman.visible = true
