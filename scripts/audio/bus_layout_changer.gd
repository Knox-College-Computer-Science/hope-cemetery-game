extends Node

@export var layout_path : String

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_layout(load(layout_path))
