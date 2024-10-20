extends Node2D

@onready var note = get_node("Note")
@onready var grimoire = get_node("Grimoire")
@onready var bible = get_node("Bible")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	note.visible = false
	grimoire.visible = false
	bible.visible = false
	
	self.visible = false
	
	EventBus.push_popup.connect(_inventory_popup)
	EventBus.close_popup.connect(_on_popup_closed)

func _inventory_popup(popup, data):
	if popup == "Inventory":
		if self.visible: self.visible = false # Toggle visibility
		else: self.visible = true
		
		var inventory = data
		if "Note" in inventory:
			note.visible = true
		if "Grimoire" in inventory:
			grimoire.visible = true
		if "Bible" in inventory:
			bible.visible = true
			
func _on_popup_closed(): self.visible = false

func _on_note_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		EventBus.emit_signal("push_popup", "Note", "")

func _on_grimoire_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		EventBus.emit_signal("push_popup", "Grimoire", "")

func _on_bible_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		EventBus.emit_signal("push_popup", "Bible", "")
