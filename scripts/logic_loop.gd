extends Node

const MIN_LOGIC_UPDATE_DURATION_MS = 100

var message_manager = preload("res://scripts/message_manager.gd").new()
var model_manager = preload("res://scripts/model_manager.gd").new()

var model_game_overed = model_manager.create_model(false)
var model_text = model_manager.create_model("Initial Text")

func _init():
	set_process(true)

var __wait_time = 0
func _process(delta):
	__wait_time += delta * 1000
	if __wait_time >= MIN_LOGIC_UPDATE_DURATION_MS:
		__wait_time = 0
		update()

func update():
	if model_game_overed.value:
		get_tree().quit()
	message_manager.update()
	model_manager.update()
	