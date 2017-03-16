# MIT License
# 
# Copyright (c) 2017 Geequlim
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
extends Reference

# Binded Views
var _view_updaters = []

# Binded Model
var _model = null
func bind_model(model):
	_model = model

# The property value is pointed to the data of the binded `Model`
var value = null setget set_value, get_value

# Get Model data
func get_value():
	if _model == null:
		return null
	return _model.value

# Update Model data --> update View with new Model data
func set_value(p_value):
	if _model != null:
		_model.value = p_value
		update_view()

# Bind a view with update callback  
# - - -  
# **params**  
# * [view: Node]: The view to be binded with   
# * [update_callback: String] The update callback function name of the view  
#  * The `update_callback` function would be called when the binded model data is changed  
func bind_view(view, update_callback):
	if view extends Node:
		if view.has_method(update_callback):
			var callback = Callback.new(view, update_callback)
			view.set_meta("ViewModel", self)
			_view_updaters.append(callback)
		else:
			printerr("ERROR[com.geequlim.mvc]: Cannot bind taraget function")
			if OS.is_debug_build():
				assert(false)
	else:
		printerr("ERROR[com.geequlim.mvc]: Cannot bind the view")
		if OS.is_debug_build():
			assert(false)

# Unbind the view  
# To remove target update callback  
# - - -  
# **params**  
# * [view: Node]: The view to unbind with  
# * [update_callback: String] = ""  
#  * The target function callback to be unbind  
#  * Unbind all binded functions with this view if pass an empty string  
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

# Update binded Views with binded Model data  
# - - -  
# **params**  
# * [view: Node] = null
#  * The view to update
#  * If pass `null` with this parameter, all of the views binded to the ViewModel would be updated
func update_view(view = null):
	if _model != null:
		for callback in _view_updaters:
			if view == null or callback.instance == view:
				callback.call_method(self.get_value())

# View update function callback    
class Callback extends Reference:
	var instance = null			# The instance of the callback function
	var func_name = ""			# The callback function name
	func _init(p_instance, p_funcname):
		instance = p_instance
		func_name = p_funcname
	
	# Call the function callback  
	# The function callback should take one parameter  
	# - - -  
	# **params**  
	# * [value: Variant] The parameter passed to the function callback  
	func call_method(value=null):
		if typeof(instance) == TYPE_OBJECT and not func_name.empty():
			if instance.has_method(func_name):
				instance.call(func_name, value)
		else:
			printerr("ERROR[com.geequlim.mvc]: call invalid callback \n", inst2dict(self))
			if OS.is_debug_build():
				assert(false)
