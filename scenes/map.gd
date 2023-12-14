extends TileMap


@onready var player: Player = $Player

func _ready():
	for node in get_tree().get_nodes_in_group(&"Neighbours"):
		node.finished.connect(_on_audio_stream_player_2d_finished.bind(node))


func _on_wall_area_body_entered(body):
	if body is Player:
		player.start_interaction(&"no_shoes")


func _on_area_body_exited(body):
	if body is Player:
		player.end_interaction()


func _on_neighbour_area_body_entered(body):
	if body is Player:
		if body.selected_item != &"horn":
			body.start_interaction(&"neighbours_no_horn")
		else:
			body.start_interaction(&"neighbours_horn")
			$NeighbourRoom/InvisibleWall.process_mode = Node.PROCESS_MODE_DISABLED


func _on_hall_iron_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y < 0:
		if not &"sword" in player.inventory:
			await globals.textbox.start_node(&"no_sword")
			fissure.teleport(player, -teleport_offset, to_room, from_room)


func _on_hall_horn_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y > 0:
		if not &"sword" in player.inventory:
			await globals.textbox.start_node(&"no_sword")
			fissure.teleport(player, -teleport_offset, to_room, from_room)


func _on_resistor_area_body_entered(body):
	if body is Player:
		if $SchneiderRoom/Schneider.state == &"unhappy":
			globals.textbox.start_node(&"schneider_incorrect")
		else:
			await globals.textbox.start_node(&"schneider_defeat")
			$Wehatstone.queue_free()


func _on_frank_ready_to_defeat():
	var delete_button := $FrankRoom/DeleteButton as Area2D
	delete_button.show()
	delete_button.monitoring = true


func _on_delete_button_body_entered(body):
	if body is Player:
		$FrankRoom/Frank.defeat()
		$FrankRoom/Shoes.process_mode = Node.PROCESS_MODE_INHERIT
		$FrankRoom/Shoes.show()
		$FrankRoom/DeleteButton.queue_free()


func _on_hall_neighbour_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y > 0:
		get_tree().call_group(&"Neighbours", &"play")
	else:
		get_tree().call_group(&"Neighbours", &"stop")


func _on_audio_stream_player_2d_finished(stream_player: AudioStreamPlayer2D):
	stream_player.play()
