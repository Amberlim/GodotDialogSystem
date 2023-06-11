extends VBoxContainer


@onready var character_node = preload("res://Objects/SubComponents/Character.tscn")
@onready var characters_container = $CharactersMainContainer/CharactersContainer

@onready var variable_node = preload("res://Objects/SubComponents/Variable.tscn")
@onready var variables_container = $VariablesMainContainer/VariablesContainer

var graph_node

var id = ""
var variables = []


func _ready():
	for character in graph_node.get_parent().speakers:
		add_character(character.get("ID"))

func _from_dict(dict):
	id = dict.get("ID")


func add_character(id: String = ""):
	var new_node = character_node.instantiate()
	characters_container.add_child(new_node)
	
	var node_index = characters_container.get_children().find(new_node)
	var id_input: LineEdit = new_node.id_input
	
	id_input.text = id
	id_input.text_changed.connect(text_submitted_callback)
	new_node.editor_index = node_index
	new_node.root_node = self
	
	update_speakers()


func add_variable():
	var new_node = variable_node.instantiate()
	variables_container.add_child(new_node)
	

func text_submitted_callback(_new_text):
	update_speakers()

func update_speakers():
	var all_nodes = characters_container.get_children()
	var updated_speakers = []
	
	for child in all_nodes:
		if child.is_queued_for_deletion():
			continue
		
		var node_index = all_nodes.find(child)
		child.editor_index = node_index
		
		updated_speakers.append(child._to_dict())
		
	graph_node.get_parent().speakers = updated_speakers
	print(graph_node.get_parent().speakers)
