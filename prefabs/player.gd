extends CharacterBody2D

class_name Player

signal on_hit
signal interact(selected_item: String)
signal item_changed(texture: Texture2D)

enum State {
	Exploring,
	Attacking
}

const Speed := 200.0
const IFramesMax := 1.7
const Knockback := 2000

@onready var animated_sprite := $AnimatedSprite2D

var can_interact := false
var fissure_level := 0

var inventory: Dictionary
var selected_item := &""
var state := State.Exploring

var iframes_counter := -1.0
var iframes := false


func _process(delta):
	# Blink after hit (iframes)
	if not iframes:
		return
		
	iframes_counter -= delta
	if iframes_counter < 0:
		visible = true
		iframes = false
	else:
		visible = not visible


func _physics_process(delta):
	var collided = false
	
	if not iframes:
		for i in get_slide_collision_count():
			var collision := get_slide_collision(i)
			var collider := collision.get_collider()
			
			if collider is Enemy:
				if collider.harmless:
					continue
				collided = true
				velocity = (position - collision.get_position()).normalized() * Knockback
				hit(collider.atk_points)
				
				break
			
	if not collided:
		velocity = Vector2.ZERO
		var direction = Input.get_vector(&"game_left", &"game_right", &"game_up", &"game_down")
		var animation = &"idle"
	
		if direction:
			velocity = direction * Speed
			animated_sprite.rotation = direction.angle() + 0.5 * PI
			animation = &"running"
	
		# Only animate when not attacking
		if state != State.Attacking:
			animated_sprite.play(animation)

	move_and_slide()


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				self.interact.emit(selected_item)
				
				if selected_item == &"sword" and state != State.Attacking:
					attack()
				elif selected_item == &"horn":
					$HornFartPlayer.play()
					
			MOUSE_BUTTON_WHEEL_DOWN:
				scroll_item(-1)
				
			MOUSE_BUTTON_WHEEL_UP:
				scroll_item(1)


func attack():
	var sword_area := $AnimatedSprite2D/SwordArea
	
	sword_area.monitoring = true
	animated_sprite.play(&"attack")
	state = State.Attacking
	
	$AttackPlayer.play()
	await animated_sprite.animation_finished
	
	sword_area.monitoring = false
	state = State.Exploring


func scroll_item(index: int):
	# Move selected item left or right depending on index
	if inventory.is_empty():
		return
		
	var current_keys := inventory.keys()
	selected_item = current_keys[
		wrapi(current_keys.find(selected_item) + index, 0, current_keys.size())]
		
	item_changed.emit(inventory[selected_item])


func hit(add_entropy: int):	
	$HurtPlayer.play()
	iframes_counter = IFramesMax
	iframes = true

	on_hit.emit()


func hit_enemy(body: Node2D):
	if body is Enemy:
		body.hit()


func take(item_type: String, texture: Texture2D):
	if &"pick" in item_type:
		item_type = &"pick"
		fissure_level += 1

	inventory[item_type] = texture


func start_interaction(text_node: String = &""):
	$Prompt.show()
	globals.textbox.queued_node = text_node
	can_interact = true


func end_interaction():
	$Prompt.hide()
	globals.textbox.queued_node = &""
	can_interact = false


func can_transverse(solidity: int) -> bool:
	return fissure_level >= solidity and selected_item == &"pick"
