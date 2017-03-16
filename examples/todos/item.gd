extends "res://addons/com.geequlim.mvc/view_model.gd"

class ItemModel:
    var value = { "content": "", "complete": false }

func bind_model(model):
    if model extends ItemModel:
        .bind_model(model)
    else:
        printerr("ERROR[todos] Bind invalid model, expect type ItemModel")

func set_content( text ):
    self.value.content = text

func set_complete( complete ):
    self.value.complete = complete
    get_param("invalidate").call_method(self)

func destory():
    get_param("destory_callback").call_method(self)
