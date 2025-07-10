extends Node


var love_letter_active: bool = false
var love_letter_comp: bool = false
var active_main_quests: bool = false
var active_side_quests: bool = false
var completed_main_quests: bool = false
var completed_side_quests: bool = false
var investigate_active: bool = true
var investigate_comp: bool = false
var masoleum_active: bool = false
var masoleum_comp: bool = false

var act_main_quest_arr = [love_letter_active,investigate_active,masoleum_active]
var act_side_quests_arr = []
var comp_side_quests_arr = []
var comp_main_quests_arr = [love_letter_comp,investigate_comp,masoleum_comp]


func update_quests():
	for quest in act_main_quest_arr:
		if quest:
			active_main_quests = true
	for quest in act_side_quests_arr:
		if quest:
			active_side_quests = true
	for quest in comp_side_quests_arr:
		if quest:
			completed_side_quests = true
	for quest in comp_main_quests_arr:
		if quest:
			completed_main_quests = true
