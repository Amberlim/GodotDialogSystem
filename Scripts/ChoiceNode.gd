extends GraphNode

var node_type = "NodeChoice"

@onready var conditionals_stack = preload("res://Objects/ConditionalsStack.tscn")
@onready var option_panel = preload("res://Objects/OptionNode.tscn")

var id = UUID.v4()

var loaded_options = []


func _ready():
	if loaded_options.size() <= 0:
		new_option()
	
	title = node_type + " (" + id + ")"
	
	for option in loaded_options:
		new_option(option.get("ID"), option.get("Sentence"), option.get("OneShot"))


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


func get_all_options_nodes():
	var nodes = []
	for child in get_children():
		if is_instance_of(child, PanelContainer) and child.id != null:
			nodes.append(child._to_dict())
	return nodes


func _on_OptionNode_close_request():
	queue_free()


func _on_More_toggled(button_pressed = null):
	new_option()


func new_option(id: String = "null", sentence: String = "", one_shot: bool = false):
	var new_option = option_panel.instantiate()
	if id != "null":
		new_option.id = id
	new_option.loaded_sentence = sentence
	new_option.loaded_one_shot = one_shot
	
	add_child(new_option)
	move_child($More, get_child_count()-1)
	if get_child_count()-2 <=0:
		set_slot(get_child_count()-2, true, 0, Color("ff2865"), true, 0, Color("097168"))
		return
	
	set_slot(get_child_count()-2, false, 0, Color("ff2865"), true, 0, Color("097168"))


func connect_all_options(node_list: Array):
	var all_options = []
	for child in get_children():
		if is_instance_of(child, PanelContainer) and child.id != null:
			all_options.append(child)
	
	var index = 0
	for option in all_options:
		var raw_option = node_list.filter(func(node): return node.get("ID") == option.id)[0]
		if raw_option == null:
			continue
		
		var next_node = get_next_node(raw_option.get("NextID"))
		get_parent().connect_node(name, index, next_node.name, 0)
		index+=1
		
func get_next_node(next_node_id):
	for node in get_parent().get_children():
		if node.id == next_node_id:
			return node
