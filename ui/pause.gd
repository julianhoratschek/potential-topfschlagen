extends Panel


func _on_button_button_down():
	get_tree().paused = false
	hide()


func _on_button_2_button_down():
	get_tree().quit()

