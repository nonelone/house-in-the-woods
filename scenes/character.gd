extends CharacterBody2D

var speed = 800
var body_name = "PC"

@onready var sprite = get_node("AnimatedSprite2D")
@onready var flashlight = get_node("Flashlight")

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	if direction == Vector2(0.0, 0.0):
		sprite.animation = "idle"
		
	else:
		sprite.animation = "walking"
		
		# Change rotation only if the player is walking to avoid it snapping to 0
		var flashlight_angle = rad_to_deg(direction.angle())
		flashlight.rotation_degrees = flashlight_angle + 90
	
	if direction.x < 0:
		sprite.flip_h = true
	if direction.x > 0:
		sprite.flip_h = false
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Border":
			print("Collided with border")

func _on_detection_body_entered(body: Node2D) -> void:
	if body.name != 'Character':
		match body.name:
			"Car":
				print("Car")
			_: pass
