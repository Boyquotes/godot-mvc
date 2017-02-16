extends Reference
var value = null setget set_value
var _dirty = false
var _arr_views = []

func bind_view(view):
    if view extends Node:
        if not view in _arr_views:
            _arr_views.append(view)

func update():
    if _dirty:
        for view in _arr_views:
            view.propagate_notification(Node.NOTIFICATION_READY)
        _dirty = false

func set_value(p_value):
    value = p_value
    _dirty = true

func steal_value(p_value):
    value = p_value