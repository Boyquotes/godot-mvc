extends Panel

var ClassMessage = preload("res://scripts/message.gd")
var Action = preload("res://scripts/actions.gd").new()

var _msg_exit = ClassMessage.new()
var _msg_changeText = ClassMessage.new()

func _init():
	_msg_exit.type = Action.ACTION_GAME_OVER
	_msg_changeText.type = Action.ACTION_CHANGE_TEXT
	_msg_changeText.params.text = "Hello World"
	logic_loop.model_text.bind_view(self)

var __signals_connected = false
func _ready():
	if not __signals_connected:
		__signals_connected = true
		get_node("btn_exit").connect(
			"pressed",
			logic_loop.message_manager,
			"post_message",
			[_msg_exit]
		)
		get_node("btn_changeTitle").connect(
			"pressed",
			logic_loop.message_manager,
			"post_message",
			[_msg_changeText]
		)
		
	self.text = logic_loop.model_text.value
	
var text = "Unset Text" setget _set_text
func _set_text(t):
	text = t
	if is_inside_tree():
		get_node("Label").set_text(t)