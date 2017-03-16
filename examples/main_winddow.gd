extends Panel
var MVC = preload("res://addons/com.geequlim.mvc/mvc.gd")


func show_todos():
	var ViewMode = preload("res://examples/todos/todos.gd")
	var TodosModel = ViewMode.TodosModel
	var model = TodosModel.new()
	var viewMode = MVC.create_viewModel(model, ViewMode)
	var view = preload("res://examples/todos/todos.tscn").instance()
	view.bind_viewModel(viewMode)
	add_child(view)

func show_calculator():
	var ViewModel = preload("res://examples/calculator/calculator.gd")
	var Model = ViewModel.Model
	var model = Model.new()
	var viewModel = MVC.create_viewModel(model, ViewModel)
	var view = preload("res://examples/calculator/calculator_view.tscn").instance()
	view.bind_viewModel(viewModel)
	add_child(view)