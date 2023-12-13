extends Control

@onready var textbox := $UI/TextBox
@onready var map := $SubViewportContainer/SubViewport/Map

func _ready():
	textbox.start_node("intro")
	
	map.player.interact.connect(textbox.call_queue)
	map.player.text_box = textbox
	
	
