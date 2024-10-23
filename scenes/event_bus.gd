extends Node

class_name Globals

signal in_range(name)
signal out_range(name)

signal interact_with(name, equipement)
signal start_ritual

signal push_message(message, duration)
signal push_awakening(message, duration)
signal push_popup(popup, data)
signal close_popup

signal add_note(note)

signal increase_haunt(amount)
signal decrease_haunt(amount)

signal next_omen

signal exited_insanity_zone
signal entered_insanity_zone(insanity_tick)

signal hit(type)

static var is_paused = false
static var popped_up = false
static var current_ending = ""

static var runes_nums = {
	0 : "",
	1 : "Life",
	2 : "Universe",
	3 : "Mankind",
	4 : "Ankh",
	5 : "Traversal",
	6 : "Oracle",
	7 : "Tesseract",
	8 : "Gate",
	9 : "Demon",
	10 : "Call"
}

static var runes = {
	"Call" : 10,
	"Demon" : 9,
	"Gate" : 8,
	"Oracle" : 6,
	"Tesseract" : 7,
	"Traversal" : 5,
	"Ankh" : 4,
	"Mankind" : 3,
	"Universe" : 2,
	"Life" : 1,
	"" : 0
}

static var rituals = {
	"Word Of Death" : ["Demon", "", "Call", ""],
	"Ascension" : ["", "", "Universe", ""],
	"Escape" : ["Mankind", "Life", "", ""],
	"Implosion" : ["Life", "", "", "Tesseract"]
}

static var known_rituals = {
	"atahxa" : ["Demon", "", "Call", ""],
	"uaxain" : ["", "", "Universe", ""],
	"iottra" : ["Life", "", "", "Tesseract"],
	"yroniz" : ["Mankind", "Life", "", ""]
}

signal pause_game
signal unpause_game

signal end_game(ending)
