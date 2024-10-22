extends Area2D

@export var connects_to = ""
@export var target = Vector2()


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		body.position = target
