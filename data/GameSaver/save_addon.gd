extends Node

@export var attributes : Array[String]
@export var class_of_object : String

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("saveable")
	if(class_of_object == ""):
		class_of_object = get_class()
