extends VBoxContainer


@onready var target_number_node = $SubContainer/TargetNumber

var graph_node

var id = ""
var target_number: int = 0
var actions: Array

func _from_dict(dict):
	id = dict.get("ID")
	target_number = dict.get("Target")
	actions = dict.get("Actions")
	
	target_number_node.value = target_number


func _on_target_number_value_changed(value):
	if value < 0 or value > 100:
		target_number_node.value = target_number
		return
	target_number = value
	graph_node.target_number = value
