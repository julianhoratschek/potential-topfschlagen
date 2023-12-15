extends VBoxContainer

class_name TextBox

# All Textblocks used by Items or Events
const nodes := {
	&"intro": [
		"Ouch!",
		"Auf dem Weg zur Sternwarte bist du im Dunkeln über einen Riss im Raumzeitkontinuum gestolpert",
		"und in einen Potentialtopf in den Tiefen des Physikzentrums gefallen.",
		"Wer weiß, was dich hier alles erwartet!",
		"Finde lieber schnell einen Weg zurück an die Oberfläche!"],
		
	&"wrong_pick": ["Oh nein! Mein Transmissionskoeffizient ist wohl nicht hoch genug."],
	
	&"no_shoes": ["Hm, hier kann ich nicht tunneln…"],
	&"with_shoes": ["Das sollte klappen!"],
	&"wonder_shoes": ["Ich brauche etwas, womit ich hier herausklettern kann."],
	
	&"no_sword": ["Hier komme ich mit Kopfrechnen nicht weiter.", "Das muss ich aufschreiben."],
	
	&"neighbours_no_horn": [
		"Was zur Hölle machen deine Nachbarn hier?",
		"LÄRM!",
		"Sie machen LÄRM!",
		"Du musst dir die Ohren zuhalten, weil du sonst wahnsinniger wirst.",
		"So kannst du nicht präzise mit der Spitzhacke arbeiten!"],
	&"neighbours_horn": [
		"Voller Rachsucht produzierst du laute Pupsgeräusche mit deinem Horn.",
		"Deine Nachbarn werden dadurch nicht leiser, aber du fühlst dich besser.",
		"Die Spitzhacke liegt dir wieder sicher in der Hand."],
	&"wonder_horn": [
		"Wenn Du sie nicht schlagen kannst, mach einfach mit!"
	],
	
	&"sword": ["Die Feder ist mächtiger als das Schwert!", "Ein Bleistift tut’s wohl auch."],
	&"shoes": ["Für die Quanten.", "Trotzdem nur an klassischen Barrieren einsetzbar.", "Style +3"],
	&"stone_pick": [
		"Eine Steinspitzhacke.",
		"Der Kopf ist wellenförmig geschwungen.",
		"Ganz okay, um durch Wände zu tunneln!"],
	&"iron_pick": [
		"Eine Eisenspitzhacke.",
		"Der Kopf ist wellenförmig geschwungen.",
		"Echt gut, um durch Wände zu tunneln!"],
	&"diamond_pick": [
		"Eine Diamantspitzhacke.",
		"Der Kopf ist wellenförmig geschwungen.",
		"Ideal, um durch Wände zu tunneln!"],
	&"horn": ["TRÖÖÖT!", "Wie ein brünftiger Elch.", "Er ist wohl horny…"],
	&"book": ["Ein Buch über Elektronik.", "Seite 314 beschreibt die Wheatstone-Brücke."],
	
	&"game_over": [
		"Quantenfluktuationen haben Anti-Neele hervorgebracht.", 
		"Du wurdest anneeleliert."],
		
	&"schneider_defeat": [
		"Herzlichen Glückwunsch!", 
		"Sie sind eine großartige Physikerin, Nelle!"],
	&"schneider_talk": [
		"Heute machen wir Wheatstone-Brücke."
	],
	&"schneider_incorrect": [
		"Das ist eine ganz komplizierte Schaltung.",
		"Sie können nicht so einfach den richtigen Widerstand finden."],
	&"wonder_book": [
		"Sie müssten mir schon zeigen, wo das steht."
	],		
		
	&"frank_intro": [
		"Huch! Ein unverbesserlicher Informatiker jagt dir seine Schlangen auf den Hals!",
		"Kämpf um dein Leben!"]
}

const TypingSpeed := 0.08

enum State {
	Typing,		# Currently writing
	Finished	# Done writing
}

# Emitted when waiting for User-Input to produce next text block
signal next_block

@onready var label := $HBoxContainer2/VBoxContainer/RichTextLabel
@onready var space_label := $HBoxContainer2/VBoxContainer/SpaceLabel

var typing_counter := 0.0
var state := State.Finished
var queued_node := &""


func _process(delta):
	# Prints out characters one by one
	if state != State.Typing:
		return
	
	typing_counter += delta
	if typing_counter < TypingSpeed:
		return
	
	typing_counter -= TypingSpeed
	label.visible_characters += 1
	if label.visible_ratio >= 1:
		$AnimationPlayer.play()
		state = State.Finished


func _input(event):
	# User can interrupt typing and display the hole text. Whenn typing is
	# finished, the user has to press space to advance the label.
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_SPACE:
		match state:
			State.Typing:
				state = State.Finished
				$AnimationPlayer.play()
				label.visible_ratio = 1
				
			State.Finished:
				next_block.emit()


func start_node(text_node: String):
	get_tree().paused = true
	show()
	
	for text in nodes[text_node]:
		label.text = text
		label.visible_ratio = 0
		
		typing_counter = 0.0
		state = State.Typing
		
		$AnimationPlayer.stop()
		space_label.visible_ratio = 0
		
		await self.next_block
		
	hide()
	queued_node = &""
	get_tree().paused = false


func call_queue(selected_item: String):
	if queued_node == &"":
		return
	
	await start_node(queued_node)
