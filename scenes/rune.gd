extends AnimatedSprite2D

@export var rune_id = 0
@export var current_rune = 0

var targeted = false

func _ready():
	EventBus.interact_with.connect(_interaction)
	
	frame = current_rune

func _interaction(body, equipement):
	if body == "Rune" and targeted:
		current_rune += 1
		if current_rune == 11:
			current_rune = 0
			
		frame = current_rune

func _on_rune_body_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		targeted = true


func _on_rune_body_body_exited(body: Node2D) -> void:
	if body.name == "Character":
		targeted = false
