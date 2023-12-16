extends Sprite2D

class_name Item

@export_enum(&"stone_pick", &"iron_pick", &"diamond_pick", &"sword", &"shoes", &"horn", &"book") 
var item_type := "horn"


func pickup(type: String, player: Player):
	var item_name := item_type
	
	if &"pick" in item_name:
		item_name = &"pick"
		player.fissure_level += 1
	
	player.inventory[item_name] = texture
	if player.selected_item == item_name:
		player.item_changed.emit(player.inventory[item_name])
	
	queue_free()


func _on_area_2d_body_entered(body: Node2D):
	if body is Player:
		body.start_interaction(item_type)
		body.interact.connect(pickup.bind(body))


func _on_area_2d_body_exited(body: Node2D):
	if body is Player:
		body.end_interaction()
		body.interact.disconnect(pickup)
