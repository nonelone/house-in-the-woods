extends Node2D

@onready var about_table = get_node("About")
@onready var credits_table = get_node("Credits")
@onready var achivements_table = get_node("Achivements")
@onready var achivement_gained = get_node("AchivementGained")

@onready var tables = [about_table, credits_table, achivements_table, achivement_gained]

var current_ending

var endings = {
	"Deatherinio" : '"Fish & Chips"\n You have been shanked.',
	"Escaperinio" : '"I\'m outa here"\n Escape before escalation.'
}

func _ready():
	#EventBus.end_game.connect(_on_end_game)
	if current_ending != "":
		_on_end_game(current_ending)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		for table in tables:
			table.visible = false

func _on_play_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_about_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		about_table.visible = true


func _on_achivements_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		achivements_table.visible = true


func _on_credits_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		credits_table.visible = true
		
func _on_end_game(ending):
	print("CUM", ending)
	if ending != null:
		print(ending)
		achivement_gained.visible = true
		$AchivementGained/GainedPatch/Label.text = endings[ending]
