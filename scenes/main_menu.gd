extends Node2D

@onready var credits_table = get_node("Credits")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		if credits_table.visible:
			credits_table.visible = false

func _on_play_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_credits_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		credits_table.visible = true
