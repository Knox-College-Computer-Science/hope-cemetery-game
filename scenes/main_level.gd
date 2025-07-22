extends Node2D

@onready var thope = $trueHopeCemetery
@onready var base_layer = $baseLayer
@onready var grave_layer = $"grave layer"
@onready var exit_area = $"Node2D/ExitArea"
@onready var map_popup  = $"Node2D/citymap/MapPopup"
@onready var player    = $PlayerCat  


func _ready():
	#$AudioStreamPlayer.play()

	map_popup.hide()
	exit_area.body_entered.connect(_on_exit_area_body_entered)
	map_popup.area_chosen.connect( Callable(self, "_on_area_chosen") )

	pass


func _on_area_2d_body_entered(body):
	glob_people.woman = true
	print(glob_people.woman)

func _on_exit_area_body_entered(body: Node) -> void:

	if body is CharacterBody2D:
		map_popup.popup()
		
func _on_area_chosen(area_id: String) -> void:
	var scene_path = ""
	match area_id:
		"OldMain":
			scene_path = "res://scenes/environments/old_main.tscn"
		"Post":
			scene_path = "res://scenes/environments/room_scene.tscn"
	
	if scene_path == "":
		printerr("No scene for area_id: %s" % area_id)
		return

	get_tree().change_scene_to_file(scene_path)
