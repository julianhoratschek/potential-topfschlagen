extends Control


func _ready():
	$AudioStreamPlayer.finished.connect($AudioStreamPlayer.play)
	
	globals.textbox = $UI/TextBox
	globals.player = $SubViewportContainer/SubViewport/Map/Player
	
	globals.player.interact.connect(globals.textbox.call_queue)
	globals.player.interact.connect($SubViewportContainer/SubViewport/Map._on_player_used_item)
	
	globals.player.item_changed.connect($UI/Inventory/BackgroundRect/ItemRect.set_texture)
	
	globals.player.on_hit.connect($UI/EntropyBar.add_entropy)
	
	globals.textbox.start_node("intro")


func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_ESCAPE:
			$SubViewportContainer/PauseMenu.show()
			get_tree().paused = true

