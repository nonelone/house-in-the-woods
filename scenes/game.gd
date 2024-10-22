extends Node2D

@onready var shadow = get_node("GameWorld/Shadow Shadow")
@onready var decals = get_node("GameWorld/Decals")
@onready var doors_area = get_node("GameWorld/Doors")

@export var haunt = 0
@export var omen_level = 0

var haunt_level = 0
var insanity_tick = 0

@export var Knife : PackedScene = preload("res://scenes/items/knife.tscn")

var painting_pos = [Vector2i(9,1), Vector2i(10,-42), Vector2i(-56,-1)]
var insanity_timer = Timer.new()

var can_shank = true

func _ready() -> void:
	#background.visible = true
	shadow.visible = true
	
	EventBus.increase_haunt.connect(_on_haunt_increase)
	EventBus.decrease_haunt.connect(_on_haunt_decrease)
	EventBus.next_omen.connect(_on_next_omen)
	EventBus.entered_insanity_zone.connect(_on_insanity_zone_entered)
	EventBus.exited_insanity_zone.connect(_on_insanity_zone_exited)
	
	add_child(insanity_timer)
	insanity_timer.wait_time = 1.0
	insanity_timer.start()
	insanity_timer.one_shot = false
	insanity_timer.connect("timeout", _on_insanity_tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if can_shank == false:
	#	await get_tree().create_timer( (6 - haunt_level) * 30.0 ).timeout
	can_shank = true

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
	if omen_level > 0:
		close_doors()
		light_candles()
	update_painting()
	
func light_candles():
	decals.set_cell(Vector2i(11,-14), 5, Vector2i(11,0))
	decals.set_cell(Vector2i(13,-14), 5, Vector2i(11,0))
	decals.set_cell(Vector2i(12,-15), 4, Vector2i(10,0))
	
func update_painting():
	for painting in painting_pos:
		match haunt_level:
			0:
				decals.set_cell(painting, 5, Vector2i(16,0))
			1:
				decals.set_cell(painting, 5, Vector2i(17,0))
			2:
				decals.set_cell(painting, 5, Vector2i(18,0))
			3:
				decals.set_cell(painting, 5, Vector2i(19,0))
			4:
				decals.set_cell(painting, 5, Vector2i(20,0))
	
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

func _on_insanity_zone_entered(tick):
	insanity_tick = tick

func _on_insanity_zone_exited():
	insanity_tick = 0
	
func _on_insanity_tick():
	if insanity_tick != 0:
		EventBus.emit_signal("increase_haunt", insanity_tick)


var loicense_for_shanking = false

# TODO: add tweakin' mechanics to singal knife attack
func _on_shank_zone_body_entered(body: Node2D) -> void:
	if haunt > 19 and can_shank:
		if body.name == "Character":
			var knoif_rotation = (Vector2(1760, -560).angle_to(body.position))
			loicense_for_shanking = true
			await get_tree().create_timer(1.0).timeout
			if loicense_for_shanking: # strike if after 1s Wren is still "seen"
				can_shank = false
				var knoif = Knife.instantiate()
				add_child(knoif)
				knoif.position = Vector2(1760, -560)
				knoif.rotation = knoif_rotation + deg_to_rad(90.0) # we live in a rotation
				EventBus.emit_signal("push_message", "What the...?", 1)

func _on_shank_zone_body_exited(body: Node2D) -> void:
	loicense_for_shanking = false
