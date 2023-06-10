extends GraphNode


@onready var option_reference = preload("res://Objects/SubComponents/OptionReference.tscn")

var _node_dict: Dictionary

var id = UUID.v4()
var node_type = "NodeChoice"
var options = []


func _ready():
	title = node_type + " (" + id + ")"


func _to_dict() -> Dictionary:
	return {
		"$type": node_type,
		"ID": id,
		"OptionsID": get_all_options_id(),
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": [],
		"EditorPosition": {
			"x": position_offset.x,
			"y": position_offset.y
		}
	}

func _from_dict(dict, global_dict):
	_node_dict = dict
	
	id = dict.get("ID")
	
	var options_id = dict.get("OptionsID")
	if options_id.size() <= 0:
		new_option_reference()
	for opt_id in options_id:
		var node = global_dict.filter(func(n): return n.get("ID") == opt_id)[0]
		options.append(node)
		new_option_reference(opt_id, node.get("Sentence"))

func new_option_reference(id = null, label: String = "Empty"):
	var new_ref = option_reference.instantiate()
	if id:
		new_ref.id = id
	
	add_child(new_ref)
	new_ref.set_label(label)
	
	var is_first = get_child_count() <= 1
	set_slot(get_child_count() - 1, is_first, 0, Color("ff2865"), true, 0, Color("097168"))


func update_option_reference(index):
	var child = get_children()[index]
	var option: Dictionary = options.filter(func(opt): return opt.get("ID") == child.id)[0]
	
	child.set_label(option.get("Sentence"))


func get_all_options_id() -> Array:
	var ids = []
	for child in get_children():
		if is_instance_of(child, PanelContainer) and child.id != null:
			ids.append(child.id)
	return ids


func _on_OptionNode_close_request():
	queue_free()


func connect_all_options(node_list: Array):
	# Clear all slots
	for child_idx in get_child_count():
		var connections = get_parent().get_all_connections_from_slot(self.name, child_idx)
		for connection in connections:
			print(connection)
	
	var all_options = []
	for child in get_children():
		all_options.append(child)
	
	var index = 0
	for option in all_options:
		var raw_option = node_list.filter(func(node): return node.get("ID") == option.id)
		if raw_option.size() <= 0:
			continue
		
		var next_node = get_next_node(raw_option[0].get("NextID"))
		if not next_node is int:
			get_parent().connect_node(name, index, next_node.name, 0)
		index+=1
		
func get_next_node(next_node_id):
	for node in get_parent().get_children():
		if not next_node_id is int and node.id == next_node_id:
			return node
	
	return -1
