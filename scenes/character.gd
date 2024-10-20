extends CharacterBody2D

var speed = 800
var interacting_with = ""

var equipement = []

@onready var sprite = get_node("AnimatedSprite2D")
@onready var flashlight = get_node("Flashlight")
@onready var tooltip = get_node("Label")

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if direction == Vector2(0.0, 0.0):
		sprite.animation = "idle"
		sprite.play()
		
	else:
		sprite.animation = "walking"
		sprite.play()
		
		# Change rotation only if the player is walking to avoid it snapping to 0
		var flashlight_angle = rad_to_deg(direction.angle())
		flashlight.rotation_degrees = flashlight_angle + 90
	
	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
	
	move_and_slide()
	
	if Input.is_action_just_pressed("interact"):
		if interacting_with != "":
			_interact()
			
	if Input.is_action_just_pressed("inventory"):
		EventBus.emit_signal("push_popup", "Inventory", equipement)
		
	if Input.is_action_just_pressed("menu"):
		EventBus.emit_signal("close_popup")

func _interact():
	EventBus.emit_signal("interact_with", interacting_with, equipement)
	if interacting_with == "Bible": equipement.append("Bible")
	elif interacting_with == "Note": equipement.append("Note")
	elif interacting_with == "Key": equipement.append("Key")
	elif interacting_with == "Grimoire":
		equipement.append("Grimoire")
		EventBus.emit_signal("next_omen") # <- this is where the fun begins
		EventBus.emit_signal("increase_haunt", 20)
		
	elif interacting_with == "Car":
		if "Note" in equipement and "Key" not in equipement:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

		
	#EventBus.emit_signal("push_popup", "Inventory", equipement) # Update inventory

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name != 'Character':
		match body.name:
			
			# Items
			"NoteBody":
				tooltip.text = "Well, isn't that note ominous?"
				interacting_with = "Note"
				EventBus.emit_signal("in_range", "Note")
			"KeyBody":
				if "Note" in equipement:
					tooltip.text = "That's the key the note is talking about!"
				else:
					tooltip.text = "That key can prove useful."
				interacting_with = "Key"
				EventBus.emit_signal("in_range", "Key")
			"BibleBody":
				tooltip.text = "Is that a Bible?\nWhy is it burned?"
				interacting_with = "Bible"
				EventBus.emit_signal("in_range", "Bible")

			"GrimoireBody":
				if "Note" in equipement and "Key" not in equipement:
					tooltip.text = "I think that is the book from the note.\nBut where's the key?"
				elif "Note" in equipement and "Key" in equipement:
					tooltip.text = "Well, here we go."
					interacting_with = "Grimoire"
				elif "Key" in equipement and "Note" not in equipement:
					tooltip.text = "The key I got before can unlock this strange book"
					interacting_with = "Grimoire"
				else:
					tooltip.text = "What a strange book.\nWhy is it locked?"
				EventBus.emit_signal("in_range", "Grimoire")

			# Areas
			"CarBody":
				if "Note" in equipement:
					tooltip.text = "I\'d better not get into it"
				else:
					tooltip.text = "I just got here..."
				interacting_with = "Car"
				EventBus.emit_signal("in_range", "Car")
			"Border":
				tooltip.text = "I'd better not walk alone in the forest at night"
			_: pass

func _on_detection_body_exited(body: Node2D) -> void:
	# clear targets since there are no "overlaping" nodes
	tooltip.text = ""
	interacting_with = ""
	if body.name != 'Character':
		EventBus.emit_signal("out_range", body.name)


func _on_detection_area_entered(area: Area2D) -> void:
	if area.name == "Doors":
		if "Grimoire" in equipement:
			tooltip.text = "Fuck! They are locked!"
