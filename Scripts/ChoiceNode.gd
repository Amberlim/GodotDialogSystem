extends GraphNode

var node_type = "NodeChoice"

@onready var conditionals_stack = preload("res://Objects/ConditionalsStack.tscn")
@onready var option_panel = preload("res://Objects/OptionNode.tscn")

var id = UUID.v4()


func _ready():
	_on_More_toggled()
	
	title = node_type + " (" + id + ")"


func _to_dict() -> Dictionary:
	return {
		"$type": node_type,
		"ID": id,
		"OptionsID": get_all_options_id(),
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func get_all_options_id() -> Array:
	var ids = []
	for child in get_children():
		if is_instance_of(child, PanelContainer) and child.id != null:
			ids.append(child.id)
	return ids


func _on_OptionNode_close_request():
	print(_to_dict())
	queue_free()


func _on_More_toggled(button_pressed = null):
	var new_option = option_panel.instantiate()
	add_child(new_option)
	move_child($More, get_child_count()-1)
	if get_child_count()-2 <=0:
		set_slot(get_child_count()-2, true, 0, Color("ff2865"), true, 0, Color("097168"))
		return
	
	set_slot(get_child_count()-2, false, 0, Color("ff2865"), true, 0, Color("097168"))
