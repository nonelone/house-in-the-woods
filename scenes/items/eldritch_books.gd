extends AnimatedSprite2D

var is_paused

var on_cooldown = false

var knowledge = [
	"Death Calls the Demon",
	"Implosion takes Life to Other Dimension",
	"Escape grants Mankind their Life",
	"Understand the Universe"
]

var knowledge_index = 0

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)
	EventBus.interact_with.connect(_interaction)

func _in_range(body): # three-letter agency glow so bright
	if body == "EldritchBooks":
		self.get_material().set_shader_parameter("width", 4)

func _out_range(body):
	if body == "EldritchBooksBody":
		self.get_material().set_shader_parameter("width", 0)

func _interaction(body, equipement): # remove it after interacting
	if body == "EldritchBooks":
		if knowledge_index < 4:
			if not on_cooldown:
				on_cooldown = true
				EventBus.emit_signal("push_message", (knowledge[knowledge_index] + "... gotta write that down." ), 2.0)
				EventBus.emit_signal("add_note", knowledge[knowledge_index])
				EventBus.emit_signal("increase_haunt", 10)
				knowledge_index += 1
				await get_tree().create_timer(30.0).timeout
				on_cooldown = false
				
		else:
			EventBus.emit_signal("push_message", "I don't see anything new...", 2.0)
