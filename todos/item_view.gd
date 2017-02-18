extends Control

var viewModel = null

func bind_viewModel(vm):
	vm.bind_view(self, "_set_item_data")
	viewModel = vm

func _set_item_data( value ):
	get_node("input").set_text(value.content)
	get_node("input").set_cursor_pos(value.content.length())
	get_node("check").set_pressed(value.complete)

func _exit_tree():
	if viewModel != null:
		viewModel.unbind_view(self)

func _ready():
	if viewModel != null:
		viewModel.update_view(self)

func _on_toggled( selected ):
	if viewModel != null:
		viewModel.set_complete( selected )

func _on_text_changed( text ):
	if viewModel != null:
		viewModel.set_content(text)

func _on_del():
	if viewModel != null:
		viewModel.destory()
