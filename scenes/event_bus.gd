extends Node

signal in_range(name)
signal out_range(name)

signal interact_with(name, equipement)

signal push_message(message, duration)
signal push_awakening(message, duration)
signal push_popup(popup, data)
signal close_popup

signal increase_haunt(amount)
signal decrease_haunt(amount)

signal next_omen

signal exited_insanity_zone
signal entered_insanity_zone(insanity_tick)

signal hit(type)

static var is_paused = false
static var popped_up = false
static var current_ending = ""

signal pause_game
signal unpause_game

signal end_game(ending)
