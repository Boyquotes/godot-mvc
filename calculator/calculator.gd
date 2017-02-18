extends "res://addons/com.geequlim.mvc/view_model.gd"

class Model:
	var value = {"curValue": "0", "expression": ""}
	func init():
		self.value = {"curValue": "0", "expression": ""}

var _last_value = 0
var _last_operator = ""
var _last_is_operator = true

func push_number(number):
	if _last_is_operator:
		self.value.curValue = number
	else:
		self.value.curValue += number
	_last_is_operator = false

func del_number():
	var length =  self.value.curValue.length()
	if length > 0:
		self.value.curValue = self.value.curValue.substr(0, length -1)

func clear():
	self._model.init()
	_last_value = 0
	_last_operator = ""
	_last_is_operator = true
	update_view()


func push_operator(operator):
	var curValue = self.value.curValue
	if _last_operator == "+":
		self.value.curValue = str( float(_last_value) + float(curValue) )
	if _last_operator == "-":
		self.value.curValue = str( float(_last_value) - float(curValue) )
	if _last_operator == "×":
		self.value.curValue = str( float(_last_value) * float(curValue) )
	if _last_operator == "÷":
		self.value.curValue = str( float(_last_value) / float(curValue) )
	if _last_operator.empty() or _last_operator == "=":
		self.value.expression = self.value.curValue
	else:
		self.value.expression = str(_last_value, _last_operator, curValue)
	_last_value = self.value.curValue
	_last_operator = operator
	_last_is_operator = true