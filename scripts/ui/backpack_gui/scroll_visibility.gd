extends PanelContainer
@onready var active_main_quest_box = $VBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/ScrollContainer/main_act_quest_box
@onready var complete_main_quest_box = $VBoxContainer/MarginContainer6/PanelContainer/ScrollContainer/main_comp_quest_box
@onready var no_act_quest_label = $VBoxContainer/MarginContainer2/PanelContainer/noQuests
@onready var no_comp_quest_label = $VBoxContainer/MarginContainer6/PanelContainer/noQuests
@onready var panel_container = $VBoxContainer/MarginContainer6/PanelContainer
@onready var comp_side_quest_box = $VBoxContainer/MarginContainer8/PanelContainer/ScrollContainer/comp_side_quest_box
@onready var active_side_quest_box = $VBoxContainer/MarginContainer4/PanelContainer/ScrollContainer/side_act_quest_box
@onready var no_comp_side_quests = $VBoxContainer/MarginContainer8/PanelContainer/noSideQuests
@onready var no_act_side_quests = $VBoxContainer/MarginContainer4/PanelContainer/noSideQuests

func update_quest_log():
	print("Quests:\n")
	var active_quest_empty: bool = true
	var complete_quest_empty: bool = true
	var n = 0
	for quest in glob_quest.main_quest_map: #iterate through all quests
		
		var status = glob_quest.main_quest_map[quest]["status"]
		var description = glob_quest.main_quest_map[quest]["description"]
		#print statements of all quests
		print("[Quest %d]" % [n])
		print("quest name: " + quest + "\nDescription: " + description + "\nStatus: " + status)
		n+=1
		if status == "active": #if the quest is active add it to the active box
			active_quest_empty = false
			add_to_quest_box(quest, description, true, true)
			
		if status == "complete":  #if the quest is complete, add it to the complete box
			complete_quest_empty = false
			add_to_quest_box(quest, description, false, true)
	
	#check if the no quest labels should pop up
	if active_quest_empty:
		no_act_quest_label.visible = true
	else:
		no_act_quest_label.visible = false
	
	if complete_quest_empty:
		no_comp_quest_label.visible = true
	else:
		no_comp_quest_label.visible = false
		
	active_quest_empty = true
	complete_quest_empty = true
	n = 0
	for quest in glob_quest.side_quest_map: #iterate through all of the side quests
		var status = glob_quest.side_quest_map[quest]["status"]
		var description = glob_quest.side_quest_map[quest]["description"]
		#print statements of all quests
		print("[Side Quest %d]" % [n])
		print("side quest name: " + quest + "\nDescription: " + description + "\nStatus: " + status)
		n+=1
		if status == "active": #if the quest is active add it to the active box
			active_quest_empty = false
			add_to_quest_box(quest, description, true, false)
			
		if status == "complete":  #if the quest is complete, add it to the complete box
			complete_quest_empty = false
			add_to_quest_box(quest, description, false, false)
	
	#check if the no quest labels should pop up
	if active_quest_empty:
		no_act_side_quests.visible = true
	else:
		no_act_side_quests.visible = false
	if complete_quest_empty:
		no_comp_side_quests.visible = true
	else:
		no_comp_side_quests.visible = false


func add_to_quest_box(quest: String, description: String, active: bool, type: bool):

	#creates the quest button
	var quest_menu_button = MenuButton.new()
	quest_menu_button.text = quest
	if active && type:
		active_main_quest_box.add_child(quest_menu_button)
	elif not active && type:
		complete_main_quest_box.add_child(quest_menu_button)
	elif active && not type:
		active_side_quest_box.add_child(quest_menu_button)
	else: #not active && not type
		comp_side_quest_box.add_child(quest_menu_button)
	
	quest_menu_button.button_down.connect(_button_clicked.bind(quest_menu_button, quest, description))
	



func _button_clicked(quest_menu_button: Button, quest: String, description: String):
	#print("you have clicked button: %s" % [quest])
	
	#create popup and make it invisible
	var quest_popup = PopupPanel.new()
	var vboxcontainer = VBoxContainer.new()
	var quest_label = Label.new()
	var close_button = Button.new()
	
	quest_label.text = description
	quest_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	quest_popup.set_size(Vector2(panel_container.size.x,0))
	quest_label.set_size(Vector2(50, 50))
	vboxcontainer.set_size(Vector2(50, 50))
	print("popup: x: %d y: %d" % [quest_popup.size.x, quest_popup.size.y])
	print("vbox: x: %d y: %d" % [vboxcontainer.size.x, vboxcontainer.size.y])
	print("label: x: %d y: %d" % [quest_label.size.x, quest_label.size.y])
	
	quest_menu_button.add_child(quest_popup)
	quest_popup.add_child(vboxcontainer)
	vboxcontainer.add_child(quest_label)
	vboxcontainer.add_child(close_button)
	
	var pos1 = quest_popup.get_parent().get_global_position() + Vector2(0, quest_menu_button.size.y)
	quest_popup.set_position(pos1)
	quest_popup.show()
	
	close_button.text = "DONE"
	close_button.button_down.connect(_hide_button_clicked.bind(quest_popup))

func _hide_button_clicked(quest_popup):
	print("hide button clicked")
	quest_popup.hide()
	
