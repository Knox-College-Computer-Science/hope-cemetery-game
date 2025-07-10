extends Node2D
@onready var thope = $trueHopeCemetery
@onready var base_layer = $baseLayer
@onready var grave_layer = $"grave layer"

func _ready():
	$AudioStreamPlayer.play()


func _on_area_2d_body_entered(body):
	glob_people.woman = true
	print(glob_people.woman)
