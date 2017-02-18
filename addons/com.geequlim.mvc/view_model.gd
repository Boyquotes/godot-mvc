extends Reference

var _view_updaters = []
var _params = {}

var _model = null

var value = null setget set_value, get_value

func bind_model(model):
	_model = model

func bind_view(view, update_callback):
	if view extends Node:
		if view.has_method(update_callback):
			var callback = Callback.new()
			callback.instance = view
			callback.func_name = update_callback
			view.set_meta("ViewModel", self)
			_view_updaters.append(callback)
		else:
			printerr("ERROR[com.geequlim.mvc]: Cannot bind update callback to presenter\n", inst2dict(view))
	else:
		printerr("ERROR[com.geequlim.mvc]: Cannot bind the view to presenter\n", inst2dict(view))

func unbind_view(view, update_callback = ""):
	var remove_idx = []
	var index = 0
	for callback in _view_updaters:
		if callback.instance == view:
			if update_callback.empty() or update_callback == callback.func_name:
				remove_idx.append(index)
		index += 1
	for idx in remove_idx:
		_view_updaters.remove(idx)

func set_param(p_name, p_param):
	_params[p_name] = p_param

func get_param(p_name):
	if _params.has(p_name):
		return _params[p_name]
	return null

func get_value():
	if _model == null:
		return null
	return _model.value

func set_value(p_value):
	if _model != null:
		_model.value = p_value
		update_view()

func update_view(view = null):
	if _model != null:
		for callback in _view_updaters:
			if view == null or callback.instance == view:
				callback.call_method(self.get_value())

class Callback extends Reference:
	var instance = null
	var func_name = ""

	func setup(p_instance, p_funcname):
		instance = p_instance
		func_name = p_funcname
		return self

	func call_method(value=null):
		if typeof(instance) == TYPE_OBJECT and not func_name.empty():
			if instance.has_method(func_name):
				instance.call(func_name, value)
		else:
			printerr("ERROR[com.geequlim.mvc]: call invalid callback \n", inst2dict(self))