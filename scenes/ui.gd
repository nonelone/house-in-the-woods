extends Node2D

@export var haunt = 0
@export var omen = "none"
@export var sanity = 100

@onready var opened_bible = get_node("OpenBible")
@onready var menu = get_node("Menu")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if opened_bible.visible:
			opened_bible.visible = false
			
		elif menu.visible:
			menu.visible = false
		else:
			menu.visible = true

func _on_bible_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		opened_bible.visible = true
