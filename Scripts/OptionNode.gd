extends PanelContainer


@onready var text_edit = $MarginContainer/VBoxContainer/HBoxContainer/TextEdit

var id = UUID.v4()
var node_type = "NodeOption"


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
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}
