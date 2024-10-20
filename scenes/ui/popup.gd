extends Node2D

@onready var note = get_node("Note")

@onready var popups = [note]
var current_popup = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.push_popup.connect(_on_popup_pushed)
	EventBus.close_popup.connect(_on_popup_closed)

func _on_popup_pushed(popup, data):
	if current_popup != null: return
	if popup == "Note":
		current_popup = "Note"
		note.visible = true

func _on_popup_closed():
	if current_popup == null: return
	for popup in popups:
		if popup != null:
			popup.visible = false
			
	current_popup = null
