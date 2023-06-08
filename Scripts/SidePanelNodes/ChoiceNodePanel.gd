extends VBoxContainer


@onready var option_panel = preload("res://Objects/SubComponents/OptionNode.tscn")
@onready var options_container = $OptionsContainer

var graph_node

var id = ""


func _from_dict(dict):
	id = dict.get("ID")
	
	for option in graph_node.options:
		new_option(option.get("ID"), option.get("Sentence"), option.get("OneShot"))


func new_option(id: String = "null", sentence: String = "", one_shot: bool = false):
	var new_option = option_panel.instantiate()
	if id != "null":
		new_option.id = id
	new_option.loaded_sentence = sentence
	new_option.loaded_one_shot = one_shot
	
	options_container.add_child(new_option)
	graph_node.set_slot(get_child_count()-1, false, 0, Color("ff2865"), true, 0, Color("097168"))


func _on_add_option_pressed():
	new_option()
