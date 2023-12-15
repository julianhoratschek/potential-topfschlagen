extends TileMap

var expecting_item := &""

func _ready():
	for node in get_tree().get_nodes_in_group(&"Neighbours"):
		node.finished.connect(_on_audio_stream_player_2d_finished.bind(node))


func _on_player_used_item(item_type: String):
	# Called everytime an Item is used (left-click)
	# Used to catch special item uses in predefined locations
	
	if item_type != expecting_item:
		match expecting_item :
			&"shoes":
				globals.textbox.start_node(&"wonder_shoes")
			&"horn":
				globals.textbox.start_node(&"wonder_horn")
			&"book":
				globals.textbox.start_node(&"wonder_book")
		return
		
	match item_type:
		&"horn":
			globals.textbox.start_node(&"neighbours_horn")
			$NeighbourRoom/InvisibleWall.process_mode = Node.PROCESS_MODE_DISABLED
			
		&"shoes":
			await globals.textbox.start_node(&"with_shoes")
			get_tree().change_scene_to_file(&"res://scenes/outro.tscn")
			
		&"book":
			globals.textbox.start_node(&"schneider_defeat")
			$SchneiderRoom/Schneider.set_happy()
			$SchneiderRoom/Wheatstone.process_mode = Node.PROCESS_MODE_DISABLED
			$SchneiderRoom/Wheatstone.hide()
			$SchneiderRoom/Resistor.show()
		

func _on_wall_area_body_entered(body):
	if body is Player:
		if &"shoes" in body.inventory:
			body.start_interaction(&"")
			expecting_item = &"shoes"
		else:
			body.start_interaction(&"no_shoes")
		


func _on_area_body_exited(body):
	if body is Player:
		globals.player.end_interaction()
		globals.textbox.queued_node = &""
		expecting_item = &""





func _on_neighbour_area_body_entered(body):
	if body is Player:
		if not &"horn" in body.inventory:
			globals.textbox.start_node(&"neighbours_no_horn")
		else:
			expecting_item = &"horn"


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
			if not &"book" in body.inventory:
				$StudyRoom/Book.show()
				$StudyRoom/Book.process_mode = Node.PROCESS_MODE_INHERIT
				
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


func _on_schneider_body_entered(body):
	if body is Player:
		if not &"book" in body.inventory:
			body.start_interaction(&"schneider_talk")
		else:
			expecting_item = &"book"
			body.start_interaction(&"")


func _on_neighbour_schneider_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if teleport_offset.y > 0:
		get_tree().call_group(&"Neighbours", &"stop")
	else:
		get_tree().call_group(&"Neighbours", &"play")


func _on_hall_frank_fissure_teleported(fissure, player, teleport_offset, from_room, to_room):
	if $FrankRoom/Frank.process_mode == Node.PROCESS_MODE_DISABLED:
		await globals.textbox.start_node(&"frank_intro")
		$FrankRoom/Frank.process_mode = Node.PROCESS_MODE_INHERIT
