extends TileMap


@onready var player: Player = $Player

func _on_wall_area_body_entered(body):
	if body is Player:
		player.start_interaction(&"no_shoes")


func _on_area_body_exited(body):
	if body is Player:
		player.end_interaction()


func _on_neighbour_area_body_entered(body):
	if body is Player:
		# TODO player state?
		body.start_interaction(&"neighbours_no_horn" 
			if body.selected_item != &"horn" else &"neighbours_horn")


func _on_hall_iron_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y < 0:
		if not "sword" in player.inventory:
			await globals.textbox.start_node("no_sword")
			fissure.teleport(player, -teleport_offset, to_room, from_room)


func _on_hall_horn_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y > 0:
		if not "sword" in player.inventory:
			await globals.textbox.start_node("no_sword")
			fissure.teleport(player, -teleport_offset, to_room, from_room)


func _on_frank_ready_to_defeat():
	var delete_button := $FrankRoom/DeleteButton as Area2D
	delete_button.show()
	delete_button.monitoring = true

func _on_delete_button_body_entered(body):
	if body is Player:
		$FrankRoom/Frank.defeat()
		$FrankRoom/Shoes.process_mode = Node.PROCESS_MODE_INHERIT
		$FrankRoom/Shoes.show()



