extends PanelContainer
@onready var clickCatcher = $".."


func _on_control_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		$"../../..".turnbutton()
