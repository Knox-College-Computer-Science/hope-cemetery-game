extends Node2D

func _ready():
	Dialogic.start("Dream")
	Dialogic.signal_event.connect(play_music)
	pass

func play_music(arg):
	if(arg == "DormMusic"):
		$AudioStreamPlayer.play()
