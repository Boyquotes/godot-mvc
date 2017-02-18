extends Panel
var MVC = preload("res://addons/com.geequlim.mvc/mvc.gd")
var ViewMode = preload("res://todos/todos.gd")
var TodosModel = ViewMode.TodosModel

var model = TodosModel.new()
var viewMode = MVC.create_viewModel(model, ViewMode)

var ClassItem = preload("res://todos/item.tscn")

func _init():
	viewMode.bind_view(self, "_update")

func _ready():
	viewMode.value = viewMode.value

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
		itemview.bind_viewMode(item)
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
	MVC.get_viewModel(self).set_filter(filter)


func _on_clear_complete():
	MVC.get_viewModel(self).clear_complete()
