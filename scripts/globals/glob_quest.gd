extends Node

#possible actions to be called
enum quest_type {
	mu_ma,
	ma_mc,
	su_sa,
	sa_sc
}

var unused_main_quest_arr = [] #Add the main quests here
var unused_side_quest_arr = [] #Add the side quests here
var act_main_quest_arr = []
var act_side_quest_arr = []
var comp_side_quest_arr = []
var comp_main_quest_arr = []

#This will be called to move quests accross arrays
func move_quest(quest: String, quest_change: quest_type):
	match quest_change:
		quest_type.mu_ma:
			print("changing main quest from unused to active")
			main_un_to_act(quest)
		quest_type.ma_mc:
			print("changing main quest from active to complete")
			main_act_to_comp(quest)
		quest_type.su_sa:
			print("changing side quest from unused to active")
			side_un_to_act(quest)
		quest_type.sa_sc:
			print("changing side quest from active to complete")
			side_act_to_comp(quest)

func main_un_to_act(quest: String):
	if(unused_main_quest_arr.has(quest) and !act_main_quest_arr.has(quest)):
		unused_main_quest_arr.erase(quest)
		act_main_quest_arr.append(quest)
	elif(act_main_quest_arr.has(quest)):
		print("The quest was already added to main active")
	else:
		print("The quest is not in main unused")

func main_act_to_comp(quest: String):
	if(act_main_quest_arr.has(quest) and !comp_main_quest_arr.has(quest)):
		act_main_quest_arr.erase(quest)
		comp_main_quest_arr.append(quest)
	elif(comp_main_quest_arr.has(quest)):
		print("The quest was already added to completed main quests")
	else:
		print("The quest is not in active main quests")

func side_un_to_act(quest: String):
	if(unused_side_quest_arr.has(quest) and !act_side_quest_arr.has(quest)):
		unused_side_quest_arr.erase(quest)
		act_side_quest_arr.append(quest)
	elif(act_side_quest_arr.has(quest)):
		print("The quest was already added to side active")
	else:
		print("The quest is not in side unused")

func side_act_to_comp(quest: String):
	if(act_side_quest_arr.has(quest) and !comp_side_quest_arr.has(quest)):
		act_side_quest_arr.erase(quest)
		comp_side_quest_arr.append(quest)
	elif(comp_side_quest_arr.has(quest)):
		print("The quest was already added to side completed")
	else:
		print("The quest is not in side active")
