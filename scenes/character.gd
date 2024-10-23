extends CharacterBody2D

var speed = 800
var interacting_with = ""

var equipement = []

var is_yapping = false
var previous_duration = 0.0
var can_move = true
var can_meditate = true

var popped_up

@onready var sprite = get_node("AnimatedSprite2D")
@onready var flashlight = get_node("Flashlight")
@onready var tooltip = get_node("Label")

func _ready() -> void:
	EventBus.push_message.connect(_on_message_pushed)
	EventBus.push_awakening.connect(_on_awakening_pushed)
	
	EventBus.hit.connect(_on_hit)
	EventBus.pause_game.connect(_on_pause)
	EventBus.unpause_game.connect(_on_unpause)

func _physics_process(delta):
	if can_move:
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity = direction * speed
		
		if direction == Vector2(0.0, 0.0):
			sprite.animation = "idle"
			sprite.play()
			$AudioStreamPlayer2D.stop()
			
		else:
			sprite.animation = "walking"
			sprite.play()
			if not $AudioStreamPlayer2D.playing:
				$AudioStreamPlayer2D.play()
			
			# Change rotation only if the player is walking to avoid it snapping to 0
			var flashlight_angle = rad_to_deg(direction.angle())
			flashlight.rotation_degrees = flashlight_angle + 90
		
		if direction.x < 0:
			sprite.flip_h = false
		if direction.x > 0:
			sprite.flip_h = true
		
		move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		if interacting_with != "":
			_interact()
			
	if Input.is_action_just_pressed("inventory"):
		EventBus.emit_signal("push_popup", "Inventory", equipement)
		
	if Input.is_action_just_pressed("menu"):
		EventBus.emit_signal("close_popup")
		can_move = true
		
	if Input.is_action_just_pressed("channel"):
		if can_meditate:
			EventBus.emit_signal("push_message","Okay Wren, chill...", 5)
			_meditate()
			can_meditate = false
			await get_tree().create_timer(30).timeout # cooldown
			can_meditate = true
		
		else:
			EventBus.emit_signal("push_message","I can't focus now!", 1.5)

func _meditate():
	can_move = false
	await get_tree().create_timer(5).timeout
	EventBus.emit_signal("decrease_haunt", 10)
	can_move = true

func _interact():
	EventBus.emit_signal("interact_with", interacting_with, equipement)
	if interacting_with == "Bible": equipement.append("Bible")
	elif interacting_with == "Note": equipement.append("Note")
	elif interacting_with == "Key": equipement.append("Key")
	elif interacting_with == "EldritchNotes": _research("notes")
	elif interacting_with == "Grimoire":
		equipement.append("Grimoire")
		EventBus.emit_signal("next_omen") # <- this is where the fun begins
		EventBus.emit_signal("increase_haunt", 20)
		
	elif interacting_with == "Car":
		if "Note" in equipement and "Key" not in equipement:
			EventBus.emit_signal("end_game", "Avoidance")
			Globals.current_ending = "Avoidance"
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _research(source):
	if source == "notes":
		can_move = false
		EventBus.emit_signal("push_awakening", "This knowledge may be yours...", 5)
		await get_tree().create_timer(5).timeout
		can_move = true

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name != 'Character':
		match body.name:
			# Items
			"NoteBody":
				EventBus.emit_signal("push_message", "Well, isn't that note ominous?", 1.5)
				interacting_with = "Note"
				EventBus.emit_signal("in_range", "Note")
			"KeyBody":
				if "Note" in equipement:
					EventBus.emit_signal("push_message", "That's the key the note is talking about!", 1)
				else:
					EventBus.emit_signal("push_message", "That key can prove useful.", 1)
				interacting_with = "Key"
				EventBus.emit_signal("in_range", "Key")
			"BibleBody":
				EventBus.emit_signal("push_message", "Is that a Bible?\nWhy is it burned?", 1.5)
				interacting_with = "Bible"
				EventBus.emit_signal("in_range", "Bible")

			"GrimoireBody":
				if "Note" in equipement and "Key" not in equipement:
					EventBus.emit_signal("push_message", "I think that is the book from the note.\nBut where's the key?", 1.5)
				elif "Note" in equipement and "Key" in equipement:
					EventBus.emit_signal("push_message", "Well, here we go.", .5)
					interacting_with = "Grimoire"
				elif "Key" in equipement and "Note" not in equipement:
					EventBus.emit_signal("push_message", "The key I got before can unlock this strange book", 1.5)
					interacting_with = "Grimoire"
				else:
					EventBus.emit_signal("push_message", "What a strange book.\nWhy is it locked?", 1.5)
				EventBus.emit_signal("in_range", "Grimoire")

			"EldritchNotesBody":
				if "Grimoire" in equipement:
					interacting_with = "EldritchNotes" # Interact only if Wren has the grimoire
					EventBus.emit_signal("push_message", "These symbols look familliar...", 2)
				else:
					EventBus.emit_signal("push_message", "These notes contain some strange symbols...", 3)
				EventBus.emit_signal("in_range", "EldritchNotes")

			"EldritchBooksBody":
				if "Grimoire" in equipement:
					interacting_with = "EldritchBooks" # Interact only if Wren has the grimoire
					EventBus.emit_signal("push_message", "Maybe this will help", 1)
				else:
					EventBus.emit_signal("push_message", "These are relly dusty books...", 3)
				EventBus.emit_signal("in_range", "EldritchBooks")
				
			"AltarBody":
				interacting_with = "Altar"
				#EventBus.emit_signal("start_ritual")

			# Areas
			"RuneBody":
				EventBus.emit_signal("in_range", "Rune")
				interacting_with = "Rune"
			"CarBody":
				if equipement == ["Note"]:
					EventBus.emit_signal("push_message", "I\'d better not get into it", .5)
				else:
					EventBus.emit_signal("push_message", "I just got here...", .5)
				interacting_with = "Car"
				EventBus.emit_signal("in_range", "Car")
			"Border":
				EventBus.emit_signal("push_message", "I'd better not walk alone in the forest at night", 1.5)
			_: pass

func _on_detection_body_exited(body: Node2D) -> void:
	# clear targets since there are no "overlaping" nodes
	interacting_with = ""
	if body.name != 'Character':
		EventBus.emit_signal("out_range", body.name)

func _on_detection_area_entered(area: Area2D) -> void:
	if area.name == "Doors":
		if "Grimoire" in equipement:
			EventBus.emit_signal("push_message", "They are locked!", .5)
			
	elif area.name == "RuneBody":
		interacting_with = "Rune"

func _on_message_pushed(message, duration):
	if is_yapping:
		await get_tree().create_timer(previous_duration / 2).timeout

	is_yapping = true
	previous_duration = duration
	tooltip.text = message
	await get_tree().create_timer(duration).timeout # Visible for the duration
	if is_yapping: # Can change extarnally
		tooltip.text = ""
		is_yapping = false

func _on_awakening_pushed(message, duration):
	# Ignore Wren's yapping
	is_yapping = true
	previous_duration = duration
	tooltip.text = message
	tooltip.modulate = Color(1.0,0.0,0.0,1.0)
	await get_tree().create_timer(duration).timeout # Visible for the duration
	tooltip.text = ""
	tooltip.modulate = Color(1.0,1.0,1.0,1.0)
	is_yapping = false

func _on_hit(thingy):
	if thingy == "knife":
		EventBus.emit_signal("end_game", "Death")
		Globals.current_ending = "Death"
		await get_tree().create_timer(.2).timeout
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_pause(): can_move = false
func _on_unpause(): can_move = true
