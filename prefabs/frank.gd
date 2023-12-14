extends CharacterBody2D

class_name Frank

const MaxVisibility = 1.2

var SnekScene = preload("res://prefabs/snek.tscn")
var sneks := Array()
var spawn_points := Array()
var visibility_counter := MaxVisibility

func _ready():
	for i in range(5):
		sneks.append(SnekScene.instantiate())
	
	spawn_points = get_tree().get_nodes_in_group("SnekSpawns")


func _process(delta):
	if visible:
		visibility_counter -= delta
		if visibility_counter > 0:
			return
		
		position = Vector2(5000, 5000)
		hide()
		spawn_sneks()
		
	else:
		for snek in sneks:
			if snek.is_alive:
				return
	
		position = spawn_points.pick_random()
		visibility_counter = MaxVisibility
		show()
	
	
func spawn_sneks():
	for snek in sneks:
		snek.spawn(spawn_points.pick_random().position)
		add_sibling(snek)
		await get_tree().create_timer(1.2).timeout
