extends Reference
var ClassMessage = preload("res://scripts/message.gd")
var Action = preload("res://scripts/actions.gd").new()

var _arr_messages = []

func post_message(msg):
    if msg extends ClassMessage:
        _arr_messages.append(msg)

func update():
    for msg in _arr_messages:
        _handle_message(msg)
    _arr_messages.clear()

func _handle_message(msg):
    if not msg extends ClassMessage:
        printerr("Cannot hanlde the message ", msg)
        return
    if msg.type == Action.ACTION_CHANGE_TEXT:
        logic_loop.model_text.value = msg.params.text
    elif msg.type == Action.ACTION_GAME_OVER:
        logic_loop.model_game_overed.value = true
    else:
        printerr("Unhandled message ", inst2dict(msg))