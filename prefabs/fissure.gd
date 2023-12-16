## "Doors" connecting rooms vertically or horizontally, managing lights
## when a room is left or entered.

extends AnimatedSprite2D

class_name Fissure

## Emittet after Player was moved through a wall
signal teleported(fissure: Fissure, player: Player, teleport_offset: Vector2, from_room: Node2D, to_room: Node2D)

@export_enum(&"horizontal", &"vertical") 
var orientation := "horizontal"

@export_enum("Stone:1", "Iron:2", "Diamond:3") 
var solidity := 1

@export var topleft_room: Node2D

@export var bottomright_room: Node2D


@onready var lefttop_area = $LeftTopArea
@onready var rightbottom_area = $RightBottomArea

## Used internally to inhibit "teleportation loops"
var _can_teleport := false


func _update_areas():
	var teleport_offset := Vector2(32, 0)
	
	animation = orientation + str(solidity)
	match(orientation):
		&"horizontal":
			$LeftTopArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_INHERIT
			$LeftTopArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_DISABLED
			$RightBottomArea/CollisionShape2D.process_mode = Node.PROCESS_MODE_INHERIT
			$RightBottomArea/CollisionShape2D2.process_mode = Node.PROCESS_MODE_DISABLED
			
		&"vertical":
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


func teleport(player: Player, teleport_offset: Vector2, from_room: Node2D, to_room: Node2D):
	player.position = position + teleport_offset
	from_room.find_child(&"PointLight2D").enabled = false
	to_room.find_child(&"PointLight2D").enabled = true


func _body_entered_area(body: Node2D, teleport_offset: Vector2, from_room: Node2D, to_room: Node2D):
	if not _can_teleport and body is Player:
		if body.can_transverse(solidity):
			teleport(body, teleport_offset, from_room, to_room)
			teleported.emit(self, body, teleport_offset, from_room, to_room)
			_can_teleport = true
		else:
			body.start_interaction(&"wrong_pick")


func _body_exited_area(body: Node2D):
	if body is Player:
		body.end_interaction()
		if _can_teleport:
			_can_teleport = false
		
