extends CanvasLayer

@export var game_saver : Node
@export var level_handler : Node
@onready var save_slots = $Panel/SaveSlots
@onready var save_button = $Panel/HBoxContainer/SaveButton
@onready var load_button = $Panel/HBoxContainer/LoadButton

var selected_slot = -1
var empty_slots = []
var most_recent_save_metadata : SaveMetadata = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_save_slots_item_selected(index):
	save_button.disabled = false
	load_button.disabled = index in empty_slots
	selected_slot = index

func _on_save_button_button_down():
	game_saver.save_level()
	game_saver.save_game(selected_slot, most_recent_save_metadata)
	reset_buttons()
	save_slots.set_item_custom_bg_color(selected_slot, Color(.5,.5,0,1))
	save_slots.set_item_text(selected_slot, "Saved!")

func _on_show_button_pressed():
	toggle_panel()

func toggle_panel(metadata: SaveMetadata = null):
	most_recent_save_metadata = metadata
	$Panel.visible = !$Panel.visible
	reset_buttons()

func reset_buttons():
	save_slots.clear()
	empty_slots.clear()
	var ind = 0
	for slot in game_saver.slot_names:
		var img = get_external_texture("user://save/"+slot+"/screenshot.png")
		if(!is_instance_valid(img)):
			img = load("res://data/GameSaver/empty.png")
			save_slots.add_item(slot+" - Empty", img)
			empty_slots.append(ind)
		else:
			save_slots.add_item(slot+" - "+game_saver.get_save_metadata(ind).save_description, img)
		ind += 1

# From: https://github.com/godotengine/godot-docs/issues/2148
func get_external_texture(path):
	var img = Image.new()
	img.load(path)
	var texture = ImageTexture.new()
	return texture.create_from_image(img)

func _on_load_button_pressed():
	game_saver.load_game(selected_slot)
	print(game_saver.get_save_metadata(selected_slot).current_level_path)
	GlobalUtilities.level_handler.switch_and_load_scene_by_path(game_saver.get_save_metadata(selected_slot).current_level_path, false)
	game_saver.load_level()
	$Panel.hide()
