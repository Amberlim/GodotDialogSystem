extends PanelContainer


@onready var text_edit = $MarginContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var one_shot: CheckBox = $MarginContainer/VBoxContainer/CheckBox

var id = UUID.v4()
var node_type = "NodeOption"
var loaded_sentence = ""
var loaded_one_shot = false


func _ready():
	text_edit.text = loaded_sentence
	one_shot.button_pressed = loaded_one_shot


func _to_dict() -> Dictionary:
	var parent = get_parent_control()
	var graph_edit = parent.get_parent()
	var index: int = -1
	for child_index in parent.get_child_count():
		if parent.get_child(child_index) == self:
			index = child_index
			
	var next_id_node = graph_edit.get_all_connections_from_slot(parent.name, index)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Sentence": text_edit.text,
		"OneShot": one_shot.button_pressed,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func _on_delete_pressed():
	queue_free()
