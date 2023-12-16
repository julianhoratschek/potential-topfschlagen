extends Control

var entropy_level := 0

func add_entropy():
	# Calls game over when entropy level is bigger than 5
	entropy_level += 1
	
	if entropy_level >= 5:
		await globals.textbox.start_node(&"game_over")
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		return
	
	var ducks = get_tree().get_nodes_in_group("Ducks")
	for i in range(0, entropy_level):
		ducks[i].show()
