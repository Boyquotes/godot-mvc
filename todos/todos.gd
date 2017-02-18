extends "res://addons/com.geequlim.mvc/view_model.gd"

var Item = preload("res://todos/item.gd")
var ItemModel = Item.ItemModel

var MVC = preload("res://addons/com.geequlim.mvc/mvc.gd")

class TodosModel:
    var value = {"items": [], "filter": "SHOW_ALL"}

func bind_model(model):
    if model extends TodosModel:
        _model = model
    else:
        printerr("ERROR[todos] Bind invalid model, expect type TodosModel")

func add_item( content ):
    var itemmodel = ItemModel.new()
    itemmodel.value = { "content": content, "complete": false }
    var item = MVC.create_viewModel(
        itemmodel,
        Item,
        {
            "destory_callback": Callback.new().setup(self, "remove_item"),
            "invalidate": Callback.new().setup(self, "invalidate"),
        }
    )
    self.value.items.append(item)
    update_view()

func remove_item(item):
    self.value.items.erase(item)
    update_view()

func set_filter(filter):
    self.value.filter = filter

func clear_complete():
    var eraseitems = []
    for item in self.value.items:
        if item.value.complete:
            eraseitems.append(item)
    for ritm in eraseitems:
        self.value.items.erase(ritm)
    update_view()

func invalidate(item):
    update_view()