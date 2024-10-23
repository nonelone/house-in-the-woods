extends Node2D

@onready var about_table = get_node("About")
@onready var credits_table = get_node("Credits")
@onready var achivements_table = get_node("Achivements")
@onready var achivement_gained = get_node("AchivementGained")

@onready var tables = [about_table, credits_table, achivements_table, achivement_gained]

var endings = {
	"Failure" : '"Black Magic"\nAre you sure you know what you\'re doing?"',
	"Death" : '"Stab"\nWren couldn\'t fly away this time.',
	"Escape" : '"Escape"\nDespite all odds, Wren managed to escape.',
	"Avoidance" : '"I\'m outa here"\nThe best idea how to survive is to run away.',
	"Word Of Death" : '"Ooops!"\nWrong ritual! But at least it worked.',
	"Implosion" : '"Ooops!"\nWrong ritual! But at least it worked.',
	"Ascension" : '"Cognition"\nWren learned more than they expected.'
}

var achivements_sprites = {
	"Locked" : 0,
	"Failure" : 3,
	"Death" : 5,
	"Escape" : 2,
	"Avoidance" : 1,
	"Word Of Death" : 3,
	"Implosion" : 3,
	"Ascension" : 4
}

func _ready():
	if Globals.current_ending != "":
		_on_end_game(Globals.current_ending)

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
	if ending != null:
		achivement_gained.visible = true
		$AchivementGained/GainedPatch/AnimatedSprite2D.frame = achivements_sprites[ending]
		$AchivementGained/GainedPatch/Label.text = endings[ending]

func _on_exit_button_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("lbm"):
		get_tree().quit()
