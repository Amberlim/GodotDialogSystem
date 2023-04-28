extends Control

var dialog = {}
var dialog_for_localisation = []

@export var file_path: String

@onready var sentence_node = preload("res://Objects/SentenceNode.tscn")
@onready var dice_roll_node = preload("res://Objects/DiceRoll.tscn")
@onready var choice_node = preload("res://Objects/ChoiceNode.tscn")
@onready var root_node = preload("res://Objects/RootNode.tscn")
@onready var option_panel = preload("res://Objects/OptionNode.tscn")

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
		if node.node_type == "NodeChoice":
			var option_nodes = node.get_all_options_nodes()
			list_nodes.append_array(option_nodes)
	
	var root_node = get_root_node(list_nodes)
	var root_node_obj = get_node_by_id(root_node.get("ID"))
	
	return {
		"RootNodeID": root_node.get("ID"),
		"ListNodes": list_nodes,
		"Characters": root_node_obj.get_characters(),
		"Variables": root_node_obj.get_variables()
	}


func get_root_node(nodes):
	for node in nodes:
		if node.get("$type") == "NodeRoot":
			return node


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
		if node.node_type != "NodeRoot":
			node.queue_free()
	graph_edit.clear_connections()


func _on_NewRoll_pressed():
	var dice_roll = dice_roll_node.instantiate()
	graph_edit.add_child(dice_roll)


func _on_save_pressed():
	var path = file_path + "/dialogs.json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	var data = JSON.stringify(_to_dict(), "\t")
	file.store_string(data)
	file.close()
	
	
func _on_project_finder_dialog_dir_selected(dir):
	match $ProjectFinderDialog.open_mode:
		0: # NEW
			var path = dir + "/config.json"
			var file = FileAccess.open(path, FileAccess.WRITE)
			var project_name = dir.split("/")[len(dir.split("/"))-1]
			
			file.store_string(Util.base_config_file(project_name))
			
			file_path = dir
			$WelcomeWindow.hide()
		1: # OPEN
			var path = dir + "/config.json"
			Util.check_config_file(path)
			
			load_project(dir)
			
			file_path = dir
			$WelcomeWindow.hide()
	file_path = dir
	
	
func load_project(path):
	var dialog_path = path + "/dialogs.json"
	assert(FileAccess.file_exists(dialog_path))
	
	var file = FileAccess.get_file_as_string(dialog_path)
	var data = JSON.parse_string(file)
	
	for node in get_tree().get_nodes_in_group("graph_nodes"):
		node.queue_free()
	graph_edit.clear_connections()
	
	var node_list = data.get("ListNodes")
	
	for node in node_list:
		var new_node
		match node.get("$type"):
			"NodeRoot":
				new_node = root_node.instantiate()
			"NodeSentence":
				new_node = sentence_node.instantiate()
				new_node.loaded_text = node.get("Sentence")
			"NodeChoice":
				new_node = choice_node.instantiate()
				
				var options = get_option_nodes(node_list, node.get("OptionsID"))
				for option in options:
					new_node.loaded_options.append(option)
			"NodeDiceRoll":
				new_node = dice_roll_node.instantiate()
		
		if not new_node:
			continue
		
		new_node.id = node.get("ID")
		graph_edit.add_child(new_node)
	
	
	for node in node_list:
		match node.get("$type"):
			"NodeRoot":
				var current_node = get_node_by_id(node.get("ID"))
				if node.get("NextID") is String:
					var next_node = get_node_by_id(node.get("NextID"))
					graph_edit.connect_node(current_node.name, 0, next_node.name, 0)
			"NodeSentence":
				var current_node = get_node_by_id(node.get("ID"))
				if node.get("NextID") is String:
					var next_node = get_node_by_id(node.get("NextID"))
					graph_edit.connect_node(current_node.name, 0, next_node.name, 0)
			"NodeChoice":
				var current_node = get_node_by_id(node.get("ID"))
				current_node.connect_all_options(node_list)
			"NodeDiceRoll":
				var current_node = get_node_by_id(node.get("ID"))
				
				if node.get("PassID") is String:
					var pass_node = get_node_by_id(node.get("PassID"))
					graph_edit.connect_node(current_node.name, 0, pass_node.name, 0)
				
				if node.get("FailID") is String:
					var fail_node = get_node_by_id(node.get("FailID"))
					graph_edit.connect_node(current_node.name, 1, fail_node.name, 0)
	
	
	graph_edit.arrange_nodes()
	graph_edit.update_speakers()
	
	
func get_node_by_id(id):
	for node in graph_edit.get_children():
		if node.id == id:
			return node
	
	
func get_option_nodes(node_list, options_id):
	var options = []
	
	for node in node_list:
		if node.get("ID") in options_id:
			options.append(node)
	return options
