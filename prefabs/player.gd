extends CharacterBody2D

class_name Player

signal dead
signal interact
signal item_changed(texture: Texture2D)

const speed := 200.0

var entropy := 0.0
var can_interact := false
var fissure_level := 0

var text_box: TextBox

var inventory: Dictionary
var selected_item := ""

# TODO interact
# TODO attack
# TODO health


func _physics_process(delta):
	velocity = Vector2.ZERO
	var direction = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	
	if direction:
		velocity = direction * speed
		$AnimatedSprite2D.animation = "running"
		$AnimatedSprite2D.rotation = direction.angle() + 0.5 * PI
	else:
		$AnimatedSprite2D.animation = "idle"

	move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if can_interact:
					interact.emit()
			MOUSE_BUTTON_WHEEL_DOWN:
				scroll_item(-1)
			MOUSE_BUTTON_WHEEL_UP:
				scroll_item(1)

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
	text_box.queued_node = text_node
	can_interact = true

func end_interaction():
	$Prompt.hide()
	can_interact = false

func can_transverse(solidity: int) -> bool:
	return fissure_level >= solidity and selected_item == "pick"
