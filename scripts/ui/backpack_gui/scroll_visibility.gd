extends PanelContainer
@onready var active_main_scroll = $VBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/ScrollContainer
@onready var active_side_scroll = $VBoxContainer/MarginContainer4/PanelContainer/ScrollContainer
@onready var complete_main_scroll = $VBoxContainer/MarginContainer6/PanelContainer/ScrollContainer
@onready var complete_side_scroll = $VBoxContainer/MarginContainer8/PanelContainer/ScrollContainer
@onready var letter_quest = $VBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/ScrollContainer/main_act_quest_box/letter_quest
@onready var noquest = $VBoxContainer/MarginContainer2/PanelContainer/noQuests
@onready var investigate_quest = $VBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/ScrollContainer/main_act_quest_box/investiage_quest
@onready var charles_quest = $VBoxContainer/MarginContainer2/PanelContainer/VBoxContainer/ScrollContainer/main_act_quest_box/masoleum
@onready var comp_investigate_quest = $VBoxContainer/MarginContainer6/PanelContainer/ScrollContainer/main_comp_quest_box/comp_investiage_quest
@onready var comp_charles_quest = $VBoxContainer/MarginContainer6/PanelContainer/ScrollContainer/main_comp_quest_box/comp_masoleum
func update_quest_log():
	
	##Checks if the no quest labels or the scroll menu should be up
	
	#checks active main quests
	if(!glob_quest.active_main_quests):
		active_main_scroll.visible = false
		noquest.visible = true
	else:
		active_main_scroll.visible = true
		noquest.visible = false
	
	#checks active side quests
	if(!glob_quest.active_side_quests):
		active_side_scroll.visible = false
	else:
		active_side_scroll.visible = true
	
	#checks completed main quests
	if(!glob_quest.completed_main_quests):
		complete_main_scroll.visible = false
		$VBoxContainer/MarginContainer6/PanelContainer/noQuests.visible = true
	else:
		complete_main_scroll.visible = true
		$VBoxContainer/MarginContainer6/PanelContainer/noQuests.visible = false
		
	#checks completed side quests
	if(!glob_quest.completed_side_quests):
		complete_side_scroll.visible = false
	else:
		complete_side_scroll.visible = true
	
	##Checks which individual quests should show up
	##investigate quest (should be better created)
	if(glob_quest.investigate_active && !glob_quest.investigate_comp):
		investigate_quest.visible = true
	elif(!glob_quest.investigate_active && glob_quest.investigate_comp):
		investigate_quest.visible = false
	elif(!glob_quest.investigate_active && !glob_quest.investigate_comp):
		comp_investigate_quest.visible = true
		
	##masoleum/charles quest (should be better created)
	
	if(glob_quest.masoleum_active && !glob_quest.masoleum_comp):
		charles_quest.visible = true
	elif(!glob_quest.masoleum_active && glob_quest.masoleum_comp):
		charles_quest.visible = false
	elif(!glob_quest.masoleum_active && !glob_quest.masoleum_comp):
		comp_charles_quest.visible = true
