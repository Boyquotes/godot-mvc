extends Panel

var ClassItem = preload("res://todos/item.tscn")
var viewModel = null

func bind_viewModel(vm):
	vm.bind_view(self, "_update")
	viewModel = vm

func _ready():
	if viewModel != null:
		viewModel.update_view(self)

func _update(todos):
	for view in get_node("ui/content/items").get_children():
		view.queue_free()
	if todos.items.size() == 0:
		get_node("ui/bottom").hide()
		return
	else:
		get_node("ui/bottom").show()
	var active_count = 0
	for item in todos.items:
		# active count
		if not item.value.complete:
			active_count += 1
		# filter
		var filter = todos.filter
		var showthisitem = filter == "SHOW_ALL"
		if not showthisitem:
			showthisitem = item.value.complete and filter == "SHOW_COMPLETE"
		if not showthisitem:
			showthisitem = (not item.value.complete) and filter == "SHOW_ACTIVE"
		if not showthisitem:
			continue
		# create item view
		var itemview = ClassItem.instance()
		itemview.bind_viewModel(item)
		itemview.set_h_size_flags(SIZE_EXPAND_FILL)
		get_node("ui/content/items").add_child(itemview)
	if active_count > 1:
		get_node("ui/bottom/left_num").set_text(str(active_count, " items left"))
	else:
		get_node("ui/bottom/left_num").set_text(str(active_count, " item left"))
	
func _on_input_text_entered( text ):
	var vm = get_meta("ViewModel")
	if vm != null:
		vm.add_item(text)
	get_node("ui/input").set_text("")


func _on_filter_change( filter ):
	if viewModel != null:
		viewModel.set_filter(filter)


func _on_clear_complete():
	if viewModel != null:
		viewModel.clear_complete()
