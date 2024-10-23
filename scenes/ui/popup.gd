extends Node2D

var is_paused
@onready var note = get_node("Note")
@onready var grimoire = get_node("Grimoire")
@onready var bible = get_node("Bible")
@onready var notepad = get_node("NotePad")

@onready var json_content = load_from_file("res://assets/entities/bible.json")
@onready var bible_quotes = JSON.new()
@onready var quotes = bible_quotes.parse_string(json_content)

@onready var popups = [note, grimoire, bible, notepad]
var current_popup = null

var praying = false

var runes
var rituals
var current_ritual = 0

func load_from_file(filePath):
	var file = FileAccess.open(filePath, FileAccess.READ)
	var content = file.get_as_text()
	return content

func _ready() -> void:
	EventBus.push_popup.connect(_on_popup_pushed)
	EventBus.close_popup.connect(_on_popup_closed)
	EventBus.add_note.connect(_on_note_added)
	
	_update_rituals()
	
func _on_popup_pushed(popup, data):
	if current_popup != null: return
	
	if popup == "NotePad":
		current_popup = "NotePad"
		notepad.visible = true
	
	
	if popup == "Note":
		current_popup = "Note"
		note.visible = true
		
	if popup == "Grimoire":
		current_popup = "Grimoire"
		grimoire.visible = true

	if popup == "Bible":
		if quotes.size() == 0:
			EventBus.emit_signal("push_message", "It's totally destroyed...", 2.0)
		elif current_popup == null:
			EventBus.emit_signal("pause_game")
			is_paused = true
			praying = true
			current_popup = "Bible"
			var id = randi() % quotes.size()
			var quote = quotes[id]
			var text = quote["text"]
			if len(text) > 180:
				text = text.erase(179, (len(text) - 180))
				text += "..."
			$Bible/Label.text = quote["id"] + "\n" + text
			bible.visible = true
			EventBus.emit_signal("push_message", "Maybe that will help", 3.0)
			await get_tree().create_timer(3.5).timeout
			EventBus.emit_signal("decrease_haunt", 40)
			EventBus.emit_signal("push_awakening", "You don't need it", 2.0)
			quotes.remove_at(id)
			
			await get_tree().create_timer(2.0).timeout
			EventBus.emit_signal("push_message", "This page burned!", 2.0)
			praying = false
			EventBus.emit_signal("unpause_game")
			EventBus.emit_signal("close_popup")

func _on_popup_closed():
	if praying: return
	if current_popup == null:
		if is_paused:
			EventBus.emit_signal("unpause_game")
			is_paused = false
		else:
			EventBus.emit_signal("pause_game")
			is_paused = true
	for popup in popups:
		if popup != null:
			popup.visible = false
			
	current_popup = null

func _on_previous_page_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		_previous_page()

func _on_next_page_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		_next_page()

func _previous_page():
	if current_ritual > 0: current_ritual -= 1
	_update_rituals()

func _next_page():
	if current_ritual < 3: current_ritual += 1
	_update_rituals()

@onready var rune_sprites = [$Grimoire/PageRight/TL, $Grimoire/PageRight/TR, $Grimoire/PageRight/BL, $Grimoire/PageRight/BR]

func _update_rituals():
	var instructions = ""
	var index = 0
	for element in Globals.known_rituals.values()[current_ritual]:
		rune_sprites[index].frame = Globals.runes[element]
		if element == "": element = "..."
		instructions += element + "\n"
		index += 1
	$Grimoire/GrimoireLabel.text = Globals.known_rituals.keys()[current_ritual] + "\n" + instructions
	
func _on_note_added(note):
	$NotePad/Label.text += (note + "\n")
