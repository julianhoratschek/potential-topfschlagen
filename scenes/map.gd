extends TileMap


@onready var player: Player = $Player

func _on_wall_area_body_entered(body):
	if body is Player:
		player.start_interaction("no_shoes")


func _on_area_body_exited(body):
	if body is Player:
		player.end_interaction()


func _on_bonitz_area_body_entered(body):
	if body is Player:
		body.start_interaction("no_sword")


func _on_neighbour_area_body_entered(body):
	if body is Player:
		body.start_interaction("neighbours_no_horn")
