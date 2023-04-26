extends Control

var dialog = {}
var dialog_for_localisation = []

@export var file_path: String

@onready var sentence_node = preload("res://Objects/SentenceNode.tscn")
@onready var dice_roll_node = preload("res://Objects/DiceRoll.tscn")
@onready var choice_node = load("res://Objects/ChoiceNode.tscn")
@onready var root_node = load("res://Objects/RootNode.tscn")

@onready var graph_edit: GraphEdit = $VBoxContainer/GraphEdit

var initial_pos = Vector2(40,40)
var option_index = 0
var node_index = 0
var all_nodes_index = 0


func _ready():
	if not file_path.is_empty():
		$WelcomeWindow.show()
	
	var new_root_node = root_node.instantiate()
	graph_edit.add_child(new_root_node)

	
func _on_Button_pressed():
	var node = sentence_node.instantiate()
	graph_edit.add_child(node)


func _to_dict() -> Dictionary:
	var list_nodes = []
	
	for node in graph_edit.get_children():
		list_nodes.append(node._to_dict())
	
	return {
		"RootNodeID": 1,
		"ListNodes": list_nodes
	}


func _on_NewOption_pressed():
	var new_choice_node = choice_node.instantiate()
	graph_edit.add_child(new_choice_node)


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	if graph_edit.get_all_connections_from_slot(from, from_slot).size() <= 0:
		graph_edit.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graph_edit.disconnect_node(from, from_slot, to, to_slot)


func _on_Clear_pressed():
	for node in get_tree().get_nodes_in_group("graph_nodes"):
		if node.name != "RootNode":
			node.queue_free()
	graph_edit.clear_connections()


func _on_NewRoll_pressed():
	var dice_roll = dice_roll_node.instantiate()
	graph_edit.add_child(dice_roll)


func _on_save_pressed():
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(JSON.new().stringify(dialog))
	file.close()
	
	$HBoxContainer/Notification.visible = true
	$HBoxContainer/Notification.visible = false


func _on_project_finder_dialog_dir_selected(dir):
	file_path = dir
