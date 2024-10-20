extends Node2D

@onready var shadow = get_node("GameWorld/Shadow Shadow")
@onready var decals = get_node("GameWorld/Decals")
@onready var doors_area = get_node("GameWorld/Doors")

@export var haunt = 0
@export var omen_level = 0

var painting_pos = Vector2i(9,1)

var haunt_level = 0

func _ready() -> void:
	#background.visible = true
	shadow.visible = true
	
	EventBus.increase_haunt.connect(_on_haunt_increase)
	EventBus.decrease_haunt.connect(_on_haunt_decrease)
	EventBus.next_omen.connect(_on_next_omen)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_haunt_increase(amount):
	haunt += amount
	if haunt > 100: haunt = 100
	haunt_level = int(haunt / 20)
	impending_doom()
	
func _on_haunt_decrease(amount):
	haunt -= amount
	if haunt < 0: haunt = 0
	haunt_level = int(haunt / 20)
	impending_doom()
	
func _on_next_omen():
	omen_level += 1
	impending_doom()
	
func impending_doom():
	close_doors()
	light_candles()
	update_painting()
	
func light_candles():
	decals.set_cell(Vector2i(11,-14), 5, Vector2i(11,0))
	decals.set_cell(Vector2i(13,-14), 5, Vector2i(11,0))
	decals.set_cell(Vector2i(12,-15), 4, Vector2i(10,0))
	
func update_painting():
	match haunt_level:
		0:
			decals.set_cell(painting_pos, 5, Vector2i(16,0))
		1:
			decals.set_cell(painting_pos, 5, Vector2i(17,0))
		2:
			decals.set_cell(painting_pos, 5, Vector2i(18,0))
		3:
			decals.set_cell(painting_pos, 5, Vector2i(19,0))
		4:
			decals.set_cell(painting_pos, 5, Vector2i(20,0))
	
func open_doors():
	decals.set_cell(Vector2i(3,8),6, Vector2i(1,0))
	decals.set_cell(Vector2i(4,8),6, Vector2i(1,0),2)
	
func close_doors():
	decals.set_cell(Vector2i(3,8),6, Vector2i(0,0))
	decals.set_cell(Vector2i(4,8),6, Vector2i(0,0),1)
	doors_area.rotation_degrees = 180


func _on_doors_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		if omen_level == 0:
			open_doors()
