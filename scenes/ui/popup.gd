extends Node2D

var is_paused
@onready var note = get_node("Note")
@onready var grimoire = get_node("Grimoire")

@onready var popups = [note, grimoire]
var current_popup = null


func _ready() -> void:
	EventBus.push_popup.connect(_on_popup_pushed)
	EventBus.close_popup.connect(_on_popup_closed)

func _on_popup_pushed(popup, data):
	if current_popup != null: return
	if popup == "Note":
		current_popup = "Note"
		note.visible = true
		
	if popup == "Grimoire":
		current_popup = "Grimoire"
		grimoire.visible = true

func _on_popup_closed():
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
