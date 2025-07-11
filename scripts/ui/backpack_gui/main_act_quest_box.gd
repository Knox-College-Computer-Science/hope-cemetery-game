extends VBoxContainer
@onready var letter_desc = $letter_quest
@onready var letter_pop = $letter_quest/love_letter_desc
@onready var investigate_desc = $investiage_quest
@onready var investigate_pop = $investiage_quest/new_hope_pop
@onready var masoleum_desc = $masoleum
@onready var masoleum_pop = $masoleum/masoleum_pop_up

## Puts the popups under the correct quest and gives a button to hide them
func _on_letter_quest_toggled(toggled_on):
	letter_pop.popup()
	var pos1 = letter_desc.get_global_position() + Vector2(0, letter_desc.size.y)
	letter_pop.set_position(pos1)

func _on_close_letter_pressed():
	letter_pop.hide()


func _on_investiage_quest_toggled(toggled_on):
	investigate_pop.popup()
	var pos1 = investigate_desc.get_global_position() + Vector2(0, investigate_desc.size.y)
	investigate_pop.set_position(pos1)

func _on_close_investigate_pressed():
	investigate_pop.hide()


func _on_masoleum_toggled(toggled_on):
	masoleum_pop.popup()
	var pos1 = masoleum_desc.get_global_position() + Vector2(0, masoleum_desc.size.y)
	masoleum_pop.set_position(pos1)


func _on_close_masoleum_pressed():
	masoleum_pop.hide()
