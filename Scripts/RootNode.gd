extends GraphNode

@onready var character_container = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer
@onready var character_add_btn = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Add
@onready var character_node = preload("res://Objects/Character.tscn")
@onready var variable_container = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer
@onready var variable_add_btn = $MarginContainer/VBoxContainer/HBoxContainer2/VBoxContainer/Add
@onready var variable_node = preload("res://Objects/Variable.tscn")

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
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func _on_add_character_pressed():
	var new_node = character_node.instantiate()
	character_container.add_child(new_node)
	
	character_container.move_child(character_add_btn, character_container.get_child_count()-1)
	
	get_parent().update_speakers(get_characters())


func _on_add_variable_pressed():
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
