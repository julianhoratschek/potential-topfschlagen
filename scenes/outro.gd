extends ParallaxBackground


func _process(delta):
	scroll_offset.y += 3


func _on_button_button_down():
	get_tree().quit()
