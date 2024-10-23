extends AnimatedSprite2D

var is_paused

func _ready():
	self.get_material().set_shader_parameter("width", 0)
	EventBus.in_range.connect(_in_range)
	EventBus.out_range.connect(_out_range)
	EventBus.interact_with.connect(_interaction)

func _in_range(body): # three-letter agency glow so bright
	if body == "EldritchNotes":
		self.get_material().set_shader_parameter("width", 10)

func _out_range(body):
	if body == "EldritchNotesBody":
		self.get_material().set_shader_parameter("width", 0)

var clue_index = 0

func _interaction(body, equipement): # remove it after interacting
	if body == "EldritchNotes":
		
		if clue_index > 7: return
		
		var clues = [ # initialized here as it has to be done *after* the rituals are changed
			[Globals.rituals["Word Of Death"][0], Globals.rituals["Word Of Death"][1]],
			[Globals.rituals["Ascension"][2], Globals.rituals["Ascension"][3]],
			[Globals.rituals["Word Of Death"][2], Globals.rituals["Word Of Death"][3]],
			[Globals.rituals["Implosion"][2], Globals.rituals["Implosion"][3]],
			[Globals.rituals["Ascension"][0], Globals.rituals["Ascension"][1]],
			[Globals.rituals["Escape"][0], Globals.rituals["Escape"][1]],
			[Globals.rituals["Implosion"][0], Globals.rituals["Implosion"][1]],
			[Globals.rituals["Escape"][2], Globals.rituals["Escape"][3]],
		]
		EventBus.emit_signal("add_note", (clues[clue_index][0] + " goes with " + clues[clue_index][1] + "..."))
		
		clue_index += 1
