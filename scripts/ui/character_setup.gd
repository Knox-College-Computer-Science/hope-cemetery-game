extends Node2D
@onready var name_input = $"name input"
@onready var major_pick = $"major pick"
@onready var next_scene = $next #should be linked to next scene!!!

var player_name = ""
var selected_major = ""
var category = ""

var major_categories = {
	"Mathematics": "Science",
	"Biology": "Science",
	"Physics": "Science",
	"Chemistry": "Science",
	"Computer Science": "Science",
	"Fine Arts": "Arts",
	"Creative Writing": "Arts",
	"Graphic Design": "Arts",
	"Dance": "Arts",
	"Music": "Arts",
	"History": "Arts", 
	"Accounting" :"Business",
	"Econnomics" :"Business",
	"Finance" :"Business",	
	"Marketing" :"Business"
}

func _ready():
	major_pick.add_item("Mathematics")
	major_pick.add_item("Biology")
	major_pick.add_item("Chemistry")
	major_pick.add_item("Physics")
	major_pick.add_item("Computer Science")
	major_pick.add_item("Fine Arts")
	major_pick.add_item("Creative Writing")
	major_pick.add_item("Chemistry")
	major_pick.add_item("Graphic Design")
	major_pick.add_item("Dance")
	major_pick.add_item("Music")
	major_pick.add_item("History")
	major_pick.add_item("Accounting")
	major_pick.add_item("Ecomonics")
	major_pick.add_item("Finance")
	major_pick.add_item("Marketing")
	

func _on_next_pressed() -> void:
	player_name = name_input.text
	selected_major = major_pick.get_item_text(major_pick.get_selected_id())
	category = major_categories.get(selected_major)
	Dialogic.VAR.PlayerDescription.Name = name_input.text
	Dialogic.VAR.PlayerDescription.Major = major_pick.text
	print("Player Name:", player_name)
	print("Selected Major:", selected_major)
	print("Category: ", category)
	
	get_tree().change_scene_to_file("res://scenes/environments/room_scene.tscn") 
	#for now next button is linked to the main scene
	#later to be linked to the another scene? 
