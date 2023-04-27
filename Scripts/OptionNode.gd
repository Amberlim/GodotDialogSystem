extends PanelContainer


@onready var text_edit = $MarginContainer/VBoxContainer/HBoxContainer/TextEdit

var id = UUID.v4()
var node_type = "NodeOption"


func _to_dict() -> Dictionary:
	return {
		"$type": node_type,
		"ID": id,
		"NextID": 0,
		"Sentence": text_edit.text,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}
