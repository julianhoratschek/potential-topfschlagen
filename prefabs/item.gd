extends Sprite2D

class_name Item

@export_enum("stone_pick", "iron_pick", "diamond_pick", "sword", "shoes", "horn") 
var item_type := "Horn"

func pickup(selected_item: String, player: Player):
	player.take(item_type, texture)
	queue_free()


func _on_area_2d_body_entered(body):
	if body is Player:
		body.start_interaction(item_type)
		body.interact.connect(pickup.bind(body))


func _on_area_2d_body_exited(body):
	if body is Player:
		body.end_interaction()
		body.interact.disconnect(pickup)
