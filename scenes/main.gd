extends Control


func _ready():
	globals.textbox = $UI/TextBox
	globals.textbox.start_node("intro")
	
	globals.player = $SubViewportContainer/SubViewport/Map/Player
	
	globals.player.interact.connect(globals.textbox.call_queue)
	globals.player.item_changed.connect($UI/Inventory.set_texture)
	
	globals.player.on_hit.connect($UI/EntropyBar.set_value_no_signal)


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ESCAPE:
			$SubViewportContainer/PauseMenu.show()
			get_tree().paused = true


func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
