extends Area2D

@export var insanity_tick = 0
@export var message = ""
@export var message_duration = 0

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":
		EventBus.emit_signal("entered_insanity_zone", insanity_tick)
		if message != "":
			EventBus.emit_signal("push_message", message, message_duration)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Character":
		EventBus.emit_signal("exited_insanity_zone")
