extends Node

var main_quest_map = { #Add the main quests here example: "First Main Quest": {"description": "This is the first quest that you got", "satus": "unused" }
	"First Main Quest": {"description": "This is the first quest that you got and I want to make the description long enough for it to go over the amount for wrapping", "status": "active" },
	"Masoleum Quest": {"description": "Enter the masoleum", "status": "complete"},
	"Letter Quest": {"description": "Return the letter", "status": "unused"}
} 
var side_quest_map = { #Add the side quests here example: "First Side Quest": {"description": "This is the first quest that you got", "satus": "unused" }
	"First Side Quest": {"description": "This is the first quest that you got and I want to make the description long enough for it to go over the amount for wrapping", "status": "complete" }
} 

#This will be called to move quests accross arrays
func move_quest(type: bool, quest: String, from: String, to: String):
	if type == true:
		print("changing a main quest")
		if main_quest_map.has(quest):
			if main_quest_map[quest]["status"] == from:
				main_quest_map[quest]["status"] = to
			print(quest + " does not currently have the status: " + from)
		print("quest not found")
	elif type == false:
		print("changing a side quest")
		if side_quest_map.has(quest):
			if side_quest_map[quest]["status"] == from:
				side_quest_map[quest]["status"] = to
			print(quest + " does not currently have the status: " + from)
		print("quest not found")
