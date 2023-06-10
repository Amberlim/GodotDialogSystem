extends VBoxContainer


@onready var option_panel = preload("res://Objects/SubComponents/OptionNode.tscn")
@onready var options_container = $OptionsContainer

var graph_node

var id = UUID.v4()


func _from_dict(dict):
	id = dict.get("ID")
	
	for option in graph_node.options:
		new_option(option)


func new_option(dict = null):
	var option = option_panel.instantiate()
	option.panel_node = self
	option.graph_node = graph_node
	
	options_container.add_child(option)
	option._from_dict(dict)
	
	graph_node.set_slot(get_child_count()-1, false, 0, Color("ff2865"), true, 0, Color("097168"))


func _on_add_option_pressed():
	new_option()