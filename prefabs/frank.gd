extends Enemy

class_name Frank

enum State {
	SpawnSneks,
	Visible,
	Defeatable
}

signal ready_to_defeat

const MaxVisibility = 2.1

var SnekScene = preload("res://prefabs/snek.tscn")
var sneks := Array()
var spawn_points := Array()
var visibility_counter := MaxVisibility
var state := State.Visible
var hit_points := 3

func _ready():
	for i in range(5):
		sneks.append(SnekScene.instantiate())
	
	spawn_points = get_tree().get_nodes_in_group("SnekSpawns")


func _process(delta):
	match state:
		State.Visible:
			visibility_counter -= delta
			if visibility_counter > 0:
				return
			
			position = Vector2(5000, 5000)
			state = State.SpawnSneks
			hide()
			spawn_sneks()
			
		State.SpawnSneks:
			for snek in sneks:
				if snek.is_alive:
					return
		
			position = spawn_points.pick_random().position
			visibility_counter = MaxVisibility
			state = State.Visible
			show()
		
		State.Defeatable:
			velocity = Vector2(20, 0).rotated(randf_range(0.0, 2 * PI))
			move_and_slide()
	
	
func spawn_sneks():
	for snek in sneks:
		snek.spawn(spawn_points.pick_random().position)
		add_sibling(snek)
		await get_tree().create_timer(1.2).timeout


func hit():
	hit_points -= 1
	if hit_points == 0:
		ready_to_defeat.emit()
		state = State.Defeatable
		$AnimatedSprite2D.play("defeatable")


func defeat():
	await globals.textbox.start_node("")
	
