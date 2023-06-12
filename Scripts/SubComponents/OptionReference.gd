extends PanelContainer


@onready var option = $MainContainer/VBoxContainer/Option
@onready var sentence_preview = $MainContainer/VBoxContainer/SentencePreview

var id = UUID.v4()
var node_type = "NodeOption"
var sentence = ""
var enable = true
var one_shot = false


func _ready():
	var index = get_parent().get_children().find(self) + 1
	option.text = "Option " + str(index)


func _to_dict():
	var graph_edit = get_parent().get_parent()
	
	var option_index = get_parent().get_children().find(self)
	var next_id_node = graph_edit.get_all_connections_from_slot(get_parent().name, option_index)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Sentence": sentence,
		"Enable": enable,
		"OneShot": one_shot,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func _from_dict(dict):
	id = dict.get("ID")
	sentence = dict.get("Sentence")
	set_label(sentence)
	enable = dict.get("Enable")
	one_shot = dict.get("OneShot")


func set_label(text):
	sentence_preview.text = text
