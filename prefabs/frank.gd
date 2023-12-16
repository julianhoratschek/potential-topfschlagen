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
var visibility_counter := MaxVisibility / 2
var state := State.Visible
var hit_points := 4

func _ready():
	spawn_points = get_tree().get_nodes_in_group(&"SnekSpawns")
	sneks = get_tree().get_nodes_in_group(&"Sneks")


func _process(delta: float):
	match state:
		State.Visible:
			visibility_counter -= delta
			if visibility_counter > 0:
				return
			
			position = Vector2(5000, 5000)
			hide()
			state = State.SpawnSneks
			for snek in sneks:
				snek.is_alive = true
				snek.is_moving = false
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
		await get_tree().create_timer(0.4).timeout


func hit():
	if state != State.Visible:
		return
		
	hit_points -= 1
	modulate = modulate.darkened(0.2)
	$HitPlayer.play()
	if hit_points == 0:
		ready_to_defeat.emit()
		state = State.Defeatable
		modulate = Color.WHITE
		$AnimatedSprite2D.play("defeatable")


func defeat():
	if not harmless:
		harmless = true
		$AnimatedSprite2D.play("die")
		
	
