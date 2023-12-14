extends Control


func _ready():
	globals.textbox = $UI/TextBox
	globals.textbox.start_node("intro")
	
	globals.player = $SubViewportContainer/SubViewport/Map/Player
	
	globals.player.interact.connect(globals.textbox.call_queue)
	globals.player.item_changed.connect($UI/Inventory.set_texture)
	
	
