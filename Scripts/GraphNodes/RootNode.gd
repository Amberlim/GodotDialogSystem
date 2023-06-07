extends GraphNode

@onready var character_container = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer
@onready var character_add_btn = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Add
@onready var character_node = preload("res://Objects/SubComponents/Character.tscn")
@onready var variable_container = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer
@onready var variable_add_btn = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Add
@onready var variable_node = preload("res://Objects/SubComponents/Variable.tscn")
@onready var actions = $MarginContainer/VBoxContainer/Actions

var id = UUID.v4()
var node_type = "NodeRoot"


func _ready():
	title = node_type + " (" + id + ")"


func _to_dict() -> Dictionary:
	var next_id_node = get_parent().get_all_connections_from_slot(name, 0)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Conditions": [],
		"Actions": actions._to_dict(),
		"Flags": [],
		"CustomProperties": [],
		"EditorPosition": {
			"x": position_offset.x,
			"y": position_offset.y
		}
	}


func add_character(id: String = ""):
	var new_node = character_node.instantiate()
	character_container.add_child(new_node)
	new_node.id_input.text = id
	new_node.id_input.text_changed.connect(text_submitted_callback)
	
	character_container.move_child(character_add_btn, character_container.get_child_count()-1)
	
	get_parent().update_speakers(get_characters())


func add_variable():
	var new_node = variable_node.instantiate()
	variable_container.add_child(new_node)
	
	variable_container.move_child(variable_add_btn, variable_container.get_child_count()-1)


func get_variables():
	var variables = []
	for child in variable_container.get_children():
		if not child is PanelContainer:
			continue
		
		variables.append(child._to_dict())
	
	return variables


func get_characters():
	var characters = []
	for child in character_container.get_children():
		if not child is PanelContainer:
			continue
		
		characters.append(child._to_dict())
	
	return characters
	
	
func text_submitted_callback(_new_text):
	get_parent().update_speakers(get_characters())
