extends Panel

var ItemClass = preload("res://scenes/ui/item.tscn")
var item = null

func _ready():
	if randi() % 2 == 0:
		item = ItemClass.instantiate()
		add_child(item)
