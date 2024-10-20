extends Sprite2D

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)

func _in_range(body): # three-letter agency glow so bright
	if body == "Car":
		get_material().set_shader_parameter("width", 5)

func _out_range(body):
	if body == "CarBody":
		self.get_material().set_shader_parameter("width", 0)
