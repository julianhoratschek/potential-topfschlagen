extends Control

var entropy_level := 0

func add_entropy():
	var ducks = get_tree().get_nodes_in_group("Ducks")
	
	entropy_level += 1
	for i in range(0, entropy_level):
		ducks[i].show()
