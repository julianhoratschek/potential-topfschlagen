extends CharacterBody2D

class_name Player

signal dead
signal interact
signal item_changed(texture: Texture2D)

enum State {
	Idle,
	Walking,
	Attacking
}

const speed := 200.0

var entropy := 0.0
var can_interact := false
var fissure_level := 0

var text_box: TextBox

var inventory: Dictionary
var selected_item := ""
var state := State.Idle
var iframes_counter := -1.0

# TODO interact
# TODO attack
# TODO health

func _process(delta):
	iframes_counter -= delta
	if iframes_counter < 0:
		visible = true
		return
	
	visible = not visible


func _physics_process(delta):
	var collided = false
	
	if iframes_counter < 0:
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			if collider is Enemy:
				velocity = (position - collision.get_position()).normalized() * 2000
				collided = true
				iframes_counter = 2.5
				break
			
	if not collided:
		velocity = Vector2.ZERO
		var direction = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	
		if direction:
			velocity = direction * speed
			$AnimatedSprite2D.rotation = direction.angle() + 0.5 * PI
	
		if state != State.Attacking:
			if direction:
				$AnimatedSprite2D.play("running")
				state = State.Walking
			else:
				state = State.Idle
				$AnimatedSprite2D.play("idle")

	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if can_interact:
					interact.emit()
					can_interact = false
				elif selected_item == "sword" and state != State.Attacking:
					attack()
			MOUSE_BUTTON_WHEEL_DOWN:
				scroll_item(-1)
			MOUSE_BUTTON_WHEEL_UP:
				scroll_item(1)


func attack():
	$AnimatedSprite2D/SwordArea.monitoring = true
	$AnimatedSprite2D.play("attack")
	state = State.Attacking
	await $AnimatedSprite2D.animation_finished
	$AnimatedSprite2D/SwordArea.monitoring = false
	$AnimatedSprite2D.play("idle")
	state = State.Idle

func scroll_item(index: int):
	if inventory.is_empty():
		return
		
	var current_keys := inventory.keys()
	var current_index := current_keys.find(selected_item)
		
	current_index += index
	if current_index < 0:
		current_index = current_keys.size() - 1
	elif current_index > current_keys.size() - 1:
		current_index = 0
	
	selected_item = current_keys[current_index]
	item_changed.emit(inventory[selected_item])

func hit(add_entropy: int):
	entropy += add_entropy
	if entropy >= 100:
		dead.emit()

func hit_enemy(body: Node2D):
	if body is Enemy:
		body.hit()

func take(item_type: String, texture: Texture2D):
	if "pick" in item_type:
		item_type = "pick"
		fissure_level += 1
		
		if selected_item == "":
			# FIXME
			scroll_item(1)

	inventory[item_type] = texture

func start_interaction(text_node: String):
	$Prompt.show()
	globals.textbox.queued_node = text_node
	can_interact = true

func end_interaction():
	$Prompt.hide()
	can_interact = false

func can_transverse(solidity: int) -> bool:
	return true
	return fissure_level >= solidity and selected_item == "pick"
