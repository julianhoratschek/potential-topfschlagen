extends VBoxContainer

class_name TextBox

signal next_block

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
	&"no_sword": ["Hier komme ich mit Kopfrechnen nicht weiter.", "Das muss ich aufschreiben."],
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
	&"book": ["Ein Physiklehrbuch.", "Das soll auch Ungläubigen helfen, das Licht zu sehen."],
	&"game_over": [
		"Quantenfluktuationen haben Anti-Neele hervorgebracht.", 
		"Du wurdest annihiliert."],
	&"schneider_defeat": [
		"Herzlichen Glückwunsch!", 
		"Sie sind eine großartige Physikerin, Nelle!"],
	&"schneider_talk": [
		"Heute machen wir Wheatstone-Brücke."
	],
	&"schneider_incorrect": [
		"Das ist eine ganz komplizierte Schaltung.",
		"Sie können nicht so einfach den richtigen Widerstand finden."],
	&"frank_intro": [
		"Huch! Ein unverbesserlicher Informatiker jagt dir seine Schlangen auf den Hals!",
		"Kämpf um dein Leben!"],
	"neighbours_no_horn": [
		"Was zur Hölle machen deine Nachbarn hier?",
		"LÄRM!",
		"Sie machen LÄRM!",
		"Du musst dir die Ohren zuhalten, weil du sonst wahnsinniger wirst.",
		"So kannst du nicht präzise mit der Spitzhacke arbeiten!"],
	"neighbours_horn": [
		"Voller Rachsucht produzierst du laute Pupsgeräusche mit deinem Horn.",
		"Deine Nachbarn werden dadurch nicht leiser, aber du fühlst dich besser.",
		"Die Spitzhacke liegt dir wieder sicher in der Hand."]
}

const typing_speed := 0.08

enum State {
	Typing,
	Finished
}

@onready var label := $HBoxContainer2/RichTextLabel

var typing_counter := 0.0
var state := State.Finished
var queued_node := ""

func _process(delta):
	if state != State.Typing:
		return
	
	typing_counter += delta
	if typing_counter < typing_speed:
		return
	
	typing_counter -= typing_speed
	label.visible_characters += 1
	if label.visible_ratio >= 1:
		state = State.Finished

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.keycode == KEY_SPACE:
			if state == State.Typing:
				state = State.Finished
				label.visible_ratio = 1
			else:
				next_block.emit()
			

func start_node(text_node: String):
	get_tree().paused = true
	show()
	for text in nodes[text_node]:
		label.text = text
		label.visible_ratio = 0
		typing_counter = 0.0
		state = State.Typing
		await self.next_block
	hide()
	queued_node = ""
	get_tree().paused = false


func call_queue(selected_item: String):
	if queued_node == &"":
		return
	
	await start_node(queued_node)
