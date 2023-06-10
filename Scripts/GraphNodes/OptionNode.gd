extends PanelContainer


@onready var sentence_node = $MarginContainer/MainContainer/SentenceContainer/TextEdit
@onready var enable_node: CheckBox = $MarginContainer/MainContainer/EnableBtn
@onready var one_shot_node: CheckBox = $MarginContainer/MainContainer/OneShotBtn
@onready var id_label: Label = $MarginContainer/MainContainer/IDLabel

var id = UUID.v4()
var node_type = "NodeOption"
var sentence = ""
var enable = true
var one_shot = false


func _to_dict() -> Dictionary:
	var parent = get_parent_control()
	var graph_edit = parent.get_parent()
	var index = parent.get_children().find(self)
	var next_id_node = graph_edit.get_all_connections_from_slot(parent.name, index)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Sentence": sentence_node.text,
		"Enable": enable_node.button_pressed,
		"OneShot": one_shot_node.button_pressed,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func _from_dict(dict):
	if dict != null:
		sentence = dict.get("Sentence")
		enable = dict.get("Enable")
		one_shot = dict.get("OneShot")
	
	sentence_node.text = sentence
	enable_node.button_pressed = enable
	one_shot_node.button_pressed = one_shot
	
	id_label.text = id + " (click to copy)"


func _on_delete_pressed():
	var parent = get_parent_control()
	queue_free()


func _on_id_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		DisplayServer.clipboard_set(id)
