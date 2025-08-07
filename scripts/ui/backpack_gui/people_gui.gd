extends CanvasLayer
@onready var person_vbox = $PanelContainer/person_vbox
@onready var panel_container = $PanelContainer

#checks what people should be showing from glob_people
func update_people():
	print("People:\n")
	var n = 0
	for person in glob_people.people_map: #iterate through all quests
		var description = glob_people.people_map[person]["description"]
		#print statements of all quests
		print("[Person %d]" % [n])
		print("Person Name: " + person + "\nDescription: " + description)
		n+=1
		if glob_people.people_map[person]["known"]:
			add_to_people_box(person, description)

func add_to_people_box(person: String, description: String):

	#creates the quest button
	var person_button = MenuButton.new()
	person_button.text = person
	person_button.icon = load("res://art/icon.svg")
	person_button.add_theme_font_size_override("font_size", 35)
	person_vbox.add_child(person_button)
	
	person_button.button_down.connect(_button_clicked.bind(person_button, person, description))

func _button_clicked(person_button: Button, person: String, description: String):
	print("you have clicked button: %s" % [person])
	
	#create popup and make it invisible
	var person_popup = PopupPanel.new()
	var vboxcontainer = VBoxContainer.new()
	var person_label = Label.new()
	var close_button = Button.new()
	
	person_label.text = description
	person_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	person_popup.set_size(Vector2(panel_container.size.x,0))
	person_label.set_size(Vector2(50, 50))
	vboxcontainer.set_size(Vector2(50, 50))
	print("popup: x: %d y: %d" % [person_popup.size.x, person_popup.size.y])
	print("vbox: x: %d y: %d" % [vboxcontainer.size.x, vboxcontainer.size.y])
	print("label: x: %d y: %d" % [person_label.size.x, person_label.size.y])
	
	person_button.add_child(person_popup)
	person_popup.add_child(vboxcontainer)
	vboxcontainer.add_child(person_label)
	vboxcontainer.add_child(close_button)
	
	var pos1 = person_popup.get_parent().get_global_position() + Vector2(0, person_button.size.y)
	person_popup.set_position(pos1)
	person_popup.show()
	
	close_button.text = "DONE"
	close_button.button_down.connect(_hide_button_clicked.bind(person_popup))

func _hide_button_clicked(person_popup):
	print("hide button clicked")
	person_popup.hide()
	
