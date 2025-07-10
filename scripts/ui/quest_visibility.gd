extends Control
@onready var quest_gui = $quest_gui
@onready var people_gui = $people_gui

signal quest_button_pressed

#on start make sure only left side is visible
func _ready():
	quest_gui.visible = false
	people_gui.visible = false
	

#hide all canvas layers
func hide_canvas():

	if not get_parent().visible:
		recurse_turn_off(self)
#checks child nodes and makes canvas layers invisible
func recurse_turn_off(node: Node):
	if node is CanvasLayer:
		print(node, node.visible)
		node.visible = false
	for child in node.get_children():
		recurse_turn_off(child)

#when the poeple button is pressed:
#it checks the global variables
#makes the quest gui invisible
#Makes the people gui visible

func _on_people_button_pressed():
	$people_gui.update_people()
	quest_gui.visible = false
	if people_gui.visible == true:
		people_gui.visible = false
	else:
		people_gui.visible = true

#when the quest button is pressed
#sends signal to the back pack to play animation
#checks the global quest variables
#makes the people gui invisible
#makes the quest gui visible
func _on_quest_journal_button_pressed():
	emit_signal("quest_button_pressed")
	glob_quest.update_quests()
	$quest_gui/PanelContainer.update_quest_log()
	people_gui.visible = false
	if quest_gui.visible:
		quest_gui.visible = false
	else:
		quest_gui.visible = true
