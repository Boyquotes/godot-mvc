var ClassModel = preload("res://scripts/model.gd")
var _arr_models = []

func create_model(value):
	var model = ClassModel.new()
	model.value = value
	_arr_models.append(model)
	return model

func update():
	for model in _arr_models:
		model.update()