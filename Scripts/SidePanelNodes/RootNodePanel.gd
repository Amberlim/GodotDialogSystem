extends VBoxContainer


@onready var character_node = preload("res://Objects/SubComponents/Character.tscn")
@onready var characters_container = $CharactersContainer
@onready var characters_add_btn = $CharactersContainer/AddBtnContainer/Add

@onready var variable_node = preload("res://Objects/SubComponents/Variable.tscn")
@onready var variables_container = $VariablesContainer
@onready var variables_add_btn = $VariablesContainer/AddBtnContainer/Add

var graph_node

var id = ""
var characters = []
var variables = []


func _from_dict(dict):
	id = dict.get("ID")


func add_character(id: String = ""):
	var new_node = character_node.instantiate()
	characters_container.add_child(new_node)
	new_node.id_input.text = id
	new_node.id_input.text_changed.connect(text_submitted_callback)
	
	characters_container.move_child(characters_add_btn, characters_container.get_child_count()-1)
	
	graph_node.characters = []
	get_parent().update_speakers()


func add_variable():
	var new_node = variable_node.instantiate()
	variables_container.add_child(new_node)
	
	variables_container.move_child(variables_add_btn, variables_container.get_child_count()-1)
	

func text_submitted_callback(_new_text):
	get_parent().update_speakers()
