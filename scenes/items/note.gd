extends AnimatedSprite2D

var is_paused

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)
	EventBus.interact_with.connect(_interaction)

func _in_range(body): # three-letter agency glow so bright
	if body == "Note":
		get_material().set_shader_parameter("width", 10)

func _out_range(body):
	if body == "NoteBody":
		self.get_material().set_shader_parameter("width", 0)

func _interaction(body, equipement): # remove it after interacting
	if body == "Note":
		EventBus.emit_signal("push_popup", "Note", "")
		queue_free()
		is_paused = true
		EventBus.emit_signal("pause_game")
		await get_tree().create_timer(2.0).timeout  # don't crash pls
		EventBus.emit_signal("push_message", "How did they know my name?", 2)
