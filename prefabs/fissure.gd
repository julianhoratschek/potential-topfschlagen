extends AnimatedSprite2D

class_name Fissure

@export_enum("horizontal", "vertical") var orientation := "horizontal"
@export_enum("Stone:1", "Iron:2", "Diamond:3") var solidity := 1
@export var topleft_room: Node2D
@export var bottomright_room: Node2D


@onready var lefttop_area = $LeftTopArea
@onready var rightbottom_area = $RightBottomArea

var can_teleport := false

func _update_areas():
	var teleport_offset := Vector2(32, 0)
	
	animation = orientation + str(solidity)
	match(orientation):
		"horizontal":
			$LeftTopArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_INHERIT
			$LeftTopArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_DISABLED
			$RightBottomArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_INHERIT
			$RightBottomArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_DISABLED
			
		"vertical":
			$LeftTopArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_DISABLED
			$LeftTopArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_INHERIT
			$RightBottomArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_DISABLED
			$RightBottomArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_INHERIT
			teleport_offset = Vector2(0, 32)
	
	lefttop_area.body_entered.connect(_body_entered_area.bind(teleport_offset, topleft_room, bottomright_room))
	rightbottom_area.body_entered.connect(_body_entered_area.bind(-teleport_offset, bottomright_room, topleft_room))
	lefttop_area.body_exited.connect(_body_exited_area)
	rightbottom_area.body_exited.connect(_body_exited_area)

func _ready():
	_update_areas()
	play()

func _body_entered_area(body, teleport_offset: Vector2, from_room, to_room):
	if not can_teleport and body is Player:
		if body.can_transverse(solidity):
			body.position = position + teleport_offset
			from_room.find_child("PointLight2D").enabled = false
			to_room.find_child("PointLight2D").enabled = true
			can_teleport = true
		else:
			body.start_interaction("wrong_pick")

func _body_exited_area(body):
	if can_teleport and body is Player:
		can_teleport = false
		# TODO
