extends Control


func _on_play_button_button_down():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_quit_button_button_down():
	get_tree().quit()
