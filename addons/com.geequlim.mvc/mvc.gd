static func make_model(p_init_value):
    return {"value": p_init_value}

static func create_viewModel(model, ViewModelScript, dict_params = {}):
    var vm = null
    if typeof(ViewModelScript) == TYPE_OBJECT and ViewModelScript.is_type("Script"):
        vm = ViewModelScript.new()
        if not vm extends preload("view_model.gd"):
            vm = null
	# expect Script extends view_model.gd with second param
    assert(vm != null)
    # expect Model with a value member
    assert(is_model(model))
    vm.bind_model(model)
    # expect Dictionary params
    assert(typeof(dict_params) == TYPE_DICTIONARY)
    for key in dict_params.keys():
        vm.set_param(key, dict_params[key])
    return vm

static func get_viewModel(view):
    if typeof(view) == TYPE_OBJECT:
        return view.get_meta("ViewModel")
    return null

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