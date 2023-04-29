extends PanelContainer


@onready var text_edit = $MarginContainer/VBoxContainer/HBoxContainer/TextEdit
@onready var one_shot: CheckBox = $MarginContainer/VBoxContainer/CheckBox
@onready var id_label: Label = $MarginContainer/VBoxContainer/IDLabel

var id = UUID.v4()
var node_type = "NodeOption"
var loaded_sentence = ""
var loaded_one_shot = false


func _ready():
	text_edit.text = loaded_sentence
	one_shot.button_pressed = loaded_one_shot
	
	id_label.text = id + " (click to copy)"


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
	var parent = get_parent_control()
	queue_free()
	parent.size.y = 0


func _on_id_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		DisplayServer.clipboard_set(id)
