extends Control
@onready var settings = $settings
@onready var credits = $credits
@onready var stats = $stats
@onready var main_menu = $VBoxContainer
@onready var time_label = $"stats/Control/stats popup/time_label"
@onready var music = $"main menu music"
@onready var music_slider = $"settings/Control/settings outline/music slider"
var playtime_s: float = 0.0

func _ready():
	settings.visible = false
	credits.visible = false
	stats.visible = false
	main_menu.visible = true
	var current_linear = db_to_linear(music.volume_db)
	music_slider.value = current_linear * 100.0

	
func _on_newgame_button_pressed() -> void:
	
	get_tree().change_scene_to_file("res://character_setup.tscn")

#func _on_settings_popup_pressed() -> void:
	#var settings = load("").instance()
	#get_tree().change_scene.add_child(settings)

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_popup_pressed() -> void:
	settings.visible = true
	main_menu.visible = false

func _on_credits_button_pressed() -> void:
	credits.visible = true
	main_menu.visible = false
	
func _on_stats_pressed() -> void:
	stats.visible = true 
	main_menu.visible = false

func _on_back_pressed() -> void:
	settings.visible = false
	main_menu.visible = true

func _on_back_2_pressed() -> void:
	credits.visible = false
	main_menu.visible = true
	
func _on_back_3_pressed() -> void:
	stats.visible = false
	main_menu.visible = true

func _on_progress_pressed() -> void:
	stats.visible = false
	main_menu.visible = false
	

func _on_achievements_pressed() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	playtime_s += delta

func _on_time_spent_pressed() -> void:
	var hours = playtime_s / 3600.0
	var msg = "time spent: %.2f hours" % hours
	time_label.text = msg

func _on_days_pressed() -> void:
	pass # Replace with function body.


func _on_music_slider_value_changed(value: float) -> void:
	#value 0-1
	var linear = clamp(value/0.5, 0.001, 1.0)
	var decibels = linear_to_db(linear)
	music.volume_db = decibels
