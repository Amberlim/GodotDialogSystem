extends PanelContainer


@onready var sentence_node = $MarginContainer/MainContainer/SentenceContainer/TextEdit
@onready var enable_node: CheckBox = $MarginContainer/MainContainer/EnableBtn
@onready var one_shot_node: CheckBox = $MarginContainer/MainContainer/OneShotBtn
@onready var id_label: Label = $MarginContainer/MainContainer/IDLabel

var panel_node
var graph_node

var id = UUID.v4()
var node_type = "NodeOption"
var sentence = ""
var enable = true
var one_shot = false


func _to_dict():
	return {
		"$type": node_type,
		"ID": id,
		"Sentence": sentence,
		"Enable": enable,
		"OneShot": one_shot
	}


func _from_dict(dict):
	if dict != null:
		id = dict.get("ID")
		sentence = dict.get("Sentence")
		enable = dict.get("Enable")
		one_shot = dict.get("OneShot")
	
	sentence_node.text = sentence
	enable_node.button_pressed = enable
	one_shot_node.button_pressed = one_shot
	
	id_label.text = id + " (click to copy)"


func _on_delete_pressed():
	queue_free()
	var option_ref = graph_node.get_children().filter(func(opt): return opt.id == id)[0]
	option_ref.queue_free()


func _on_id_label_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		DisplayServer.clipboard_set(id)


func _on_text_edit_text_changed():
	sentence = sentence_node.text
	update_ref()


func _on_enable_btn_toggled(button_pressed):
	enable = button_pressed
	update_ref()


func _on_one_shot_btn_toggled(button_pressed):
	one_shot = button_pressed
	update_ref()


func update_ref():
	if is_queued_for_deletion():
		graph_node.delete_option_reference(id)
		return
	var option_ref = graph_node.get_children().filter(func(opt): return opt.id == id)[0]
	var option_index = graph_node.get_children().find(option_ref)
	
	graph_node.update_option_reference(option_index, _to_dict())
