extends AnimatedSprite2D

var is_paused

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)
	EventBus.interact_with.connect(_interaction)

func _in_range(body): # three-letter agency glow so bright
	if body == "EldritchNotes":
		get_material().set_shader_parameter("width", 10)

func _out_range(body):
	if body == "EldritchNotesBody":
		self.get_material().set_shader_parameter("width", 0)

func _interaction(body, equipement): # remove it after interacting
	if body == "EldritchNotes":
		EventBus.emit_signal("push_message", "How did they know my name?", 2)
