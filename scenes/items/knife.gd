extends Area2D

var speed = 4000
var enabled = true

@onready var hit_player = get_node("HitPlayer")

func _physics_process(delta):
	if enabled:
		position += transform.x * speed * delta

func _on_knife_entered(body: Node2D) -> void:
	if enabled == false: return
	if body.name == "Character":
		EventBus.emit_signal("hit", "knife")
		hit_player.play()
		await get_tree().create_timer(.2).timeout # Let them hear their demise
		queue_free()
	elif body.name == "World":
		position.x += -20
		enabled = false

		await get_tree().create_timer(60.0).timeout # disappear after a minute
		queue_free()
