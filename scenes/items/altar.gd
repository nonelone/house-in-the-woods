extends AnimatedSprite2D

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)
	EventBus.interact_with.connect(_interaction)

func _in_range(body): # three-letter agency glow so bright
	if body == "Altar":
		get_material().set_shader_parameter("width", 10)

func _out_range(body):
	if body == "AltarBody":
		self.get_material().set_shader_parameter("width", 0)

func _interaction(body, equipement):
	if body == "Altar":
		EventBus.emit_signal("start_ritual")
