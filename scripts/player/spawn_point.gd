extends Sprite2D

@export var spawn_point_name : String
@export var show_point = false

func _ready():
	$Label.text = spawn_point_name
	if(!show_point):
		hide()
	else:
		$Label.show()
