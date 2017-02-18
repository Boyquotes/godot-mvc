extends Panel

var viewModel = null

func bind_viewModel(p_vm):
	p_vm.bind_view(self, "_refresh")
	viewModel = p_vm

func _ready():
	if viewModel != null:
		for row in get_node("ui/buttons").get_children():
			for btn in row.get_children():
				var label = btn.get_text()
				if label in ['0','1','2','3','4','5','6','7','8','9','.']:
					btn.connect("pressed", self, "_on_number", [label])
				elif label == "C":
					btn.connect("pressed", self, "_clear")
				elif label == "←":
					btn.connect("pressed", self, "_del_number")
				else:
					btn.connect("pressed", self, "_on_operator", [label])
		viewModel.update_view(self)

func _refresh(value):
	get_node("ui/history").set_text(value.expression)
	get_node("ui/screen").set_text(value.curValue)

func _del_number():
	if viewModel != null:
		viewModel.del_number()

func _clear():
	if viewModel != null:
		viewModel.clear()

func _on_number(number):
	if viewModel != null:
		viewModel.push_number(number)

func _on_operator(operator):
	if viewModel != null:
		viewModel.push_operator(operator)
		