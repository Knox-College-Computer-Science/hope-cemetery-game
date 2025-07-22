extends Node2D

@onready var back_btn = $UI/Home

func _ready() -> void:
	back_btn.pressed.connect( Callable(self, "_on_back_pressed") )

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/environments/main_level.tscn")
