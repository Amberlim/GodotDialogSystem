extends VBoxContainer


@onready var option_panel = preload("res://Objects/SubComponents/OptionNode.tscn")
@onready var options_container = $OptionsContainer

var graph_node

var id = UUID.v4()


func _from_dict(dict):
	id = dict.get("ID")
	
	for option in graph_node.get_children():
		new_option(option._to_dict(), true)


func new_option(dict = null, init: bool = false):
	var option = option_panel.instantiate()
	option.panel_node = self
	option.graph_node = graph_node
	
	options_container.add_child(option)
	option._from_dict(dict)
	
	if not init:
		update_all_options()
		graph_node.new_option_reference(dict)
	
	graph_node.set_slot(get_child_count()-1, false, 0, Color("ff2865"), true, 0, Color("097168"))


func update_all_options():
	var updated_options = []
	for child in graph_node.get_children():
		if child.is_queued_for_deletion():
			continue
		updated_options.append(child._to_dict())
	
	graph_node.options = updated_options


func _on_add_option_pressed():
	new_option()
