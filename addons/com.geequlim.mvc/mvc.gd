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
extends Node

# Wrap a variable to a `Model`  
# - - -  
# **params**  
# * [p_init_value: Variant] The data to be wrapped
# - - -  
# **Return**  
# * [Dictionary] Wrapped as {"value": p_init_value}  
static func make_model(p_init_value):
    return {"value": p_init_value}

# Create the a ViewModel
#   
# - - -  
# **params**  
# * [model: Model]  
#  * The data bind to ViewModel to be created  
# * [ViewModelScript: Script]
#  * The script to create the instance of the ViewModel  
#  * Note: The Script muset extends from `res://addons/com.geequlim.mvc/view_model.gd`  
# * [dict_params: Dictionary] = {}
#  * Additional params of the ViewModel
# - - -  
# **Return**  
# * [ViewModel: ViewModelScript | null]  
# The created ViewModel or `null` if creation failed
static func create_viewModel(model, ViewModelScript, dict_params = {}):
    var vm = null
    if typeof(ViewModelScript) == TYPE_OBJECT and ViewModelScript.is_type("Script"):
        vm = ViewModelScript.new()
        if not vm extends preload("view_model.gd"):
            vm = null
    if OS.is_debug_build():
        # expect Script extends view_model.gd with second param
        assert(vm != null)
        # expect Model with a value member
        assert(is_model(model))
    if vm != null:
        vm.bind_model(model)
        if typeof(dict_params) == TYPE_DICTIONARY:
            for key in dict_params.keys():
                vm.set_param(key, dict_params[key])
        else:
            vm = null
            # expect Dictionary params
            if OS.is_debug_build():
                assert(vm != null)
    return vm

# Get the ViewModel of a view  
# - - -  
# **params**  
# * [view: Node] The view object
# - - -  
# **Return**  
# * [ViewModel | null] The ViewModel of the view or null  
static func get_viewModel(view):
    if typeof(view) == TYPE_OBJECT:
        return view.get_meta("ViewModel")
    return null

# Check target is a `Model`  
# - - -  
# **params**  
# * [model: Variant] The target to check with  
# - - -  
# **Return**  
# * [bool] The parameter model is a `Model`  
static func is_model(model):
    var dict = null
    if typeof(model) == TYPE_OBJECT:
        dict = inst2dict(model)
    elif typeof(model) == TYPE_DICTIONARY:
        dict = model
    if dict != null and dict.has("value"):
        return true
    else:
        return false
