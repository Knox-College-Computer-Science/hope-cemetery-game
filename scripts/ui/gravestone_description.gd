extends CanvasLayer

const PICTURE_POSITION_OFFSET = 100
const PICTURE_ROTATION_OFFSET = 4;

var labels = []
var pictures = []

func _ready():
	appear()

func appear():
	for child in $Panel.get_children():
		if(child is Label || child is RichTextLabel):
			if(child.name.to_lower() != "title"):
				child.visible_ratio = 0
				labels.append(child)
		else:
			child.modulate = Color(1, 1, 1, 0)
			pictures.append(child)
	await get_tree().create_timer(.2).timeout
	
	# Sort elements by their y position on the page
	labels.sort_custom(func(a, b): return a.position.y < b.position.y)
	pictures.sort_custom(func(a, b): return a.position.y < b.position.y)
	
	# Start showing the elements one at a time.
	show_picture(0)
	show_text(0)

func show_text(ind):
	if(ind >= labels.size()):
		return
	var t := get_tree().create_tween()
	t.tween_property(labels[ind], "visible_ratio", 1, .8).set_trans(Tween.TRANS_LINEAR)
	t.finished.connect(show_text.bind(ind+1))

func show_picture(ind):
	if(ind >= pictures.size()):
		return
		
	if(pictures[ind].rotation != 0):
		pictures[ind].rotation += PICTURE_ROTATION_OFFSET
	else:
		pictures[ind].position.y += PICTURE_POSITION_OFFSET
	var t := get_tree().create_tween()
	t.tween_property(pictures[ind], "modulate", Color.WHITE, .7).set_trans(Tween.TRANS_CUBIC)
	if(pictures[ind].rotation != 0):
		t.set_parallel().tween_property(pictures[ind], "rotation", pictures[ind].rotation - PICTURE_ROTATION_OFFSET, .7).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	else:
		t.set_parallel().tween_property(pictures[ind], "position", pictures[ind].position - Vector2(0, PICTURE_POSITION_OFFSET), .7).set_trans(Tween.TRANS_CUBIC)
	t.finished.connect(show_picture.bind(ind+1))
