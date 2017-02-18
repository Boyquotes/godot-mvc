extends Control

var MVC = preload("res://addons/com.geequlim.mvc/mvc.gd")

func bind_viewMode(viewMode):
	viewMode.bind_view(self, "_set_item_data")

func _set_item_data( value ):
	get_node("input").set_text(value.content)
	get_node("input").set_cursor_pos(value.content.length())
	get_node("check").set_pressed(value.complete)

func _exit_tree():
	MVC.get_viewModel(self).unbind_view(self)

func _ready():
	MVC.get_viewModel(self).update_view(self)

func _on_toggled( selected ):
	MVC.get_viewModel(self).set_complete( selected )

func _on_text_changed( text ):
	MVC.get_viewModel(self).set_content(text)

func _on_del():
	MVC.get_viewModel(self).destory()
