extends PanelContainer


@onready var label_id = $MarginContainer/ScrollContainer/PanelContainer/HBoxContainer/LabelID
@onready var panel_container = $MarginContainer/ScrollContainer/PanelContainer
@onready var graph_edit = $"../../GraphEdit"
@onready var control_node = $"../../../.."

@onready var root_node_panel_instance = preload("res://Objects/SidePanelNodes/RootNodePanel.tscn")
@onready var sentence_node_panel_instance = preload("res://Objects/SidePanelNodes/SentenceNodePanel.tscn")
@onready var choice_node_panel_instance = preload("res://Objects/SidePanelNodes/ChoiceNodePanel.tscn")

var selected_node = null
var current_panel = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

func clear_current_panel():
	graph_edit.speakers
	if current_panel:
		current_panel.queue_free()
		current_panel = null


func _on_graph_edit_node_selected(node):
	clear_current_panel()
	
	if node.node_type == "NodeEndPath":
		return
	
	label_id.text = node.id

	var new_panel = null
	match node.node_type:
		"NodeRoot":
			new_panel = root_node_panel_instance.instantiate()
		"NodeSentence":
			new_panel = sentence_node_panel_instance.instantiate()
		"NodeChoice":
			new_panel = choice_node_panel_instance.instantiate()
	
	new_panel.graph_node = node
	
	if new_panel:
		current_panel = new_panel
		panel_container.add_child(new_panel)
		new_panel._from_dict(node._to_dict())
		
	show()


func _on_texture_button_pressed():
	hide()


func _on_config_pressed():
	clear_current_panel()
	
	var root_node = control_node.root_node_ref

	var new_panel = root_node_panel_instance.instantiate()
	new_panel.graph_node = root_node
	current_panel = new_panel
	
	panel_container.add_child(new_panel)
	new_panel._from_dict(root_node._to_dict())
	
	label_id.text = root_node.id
	
	show()
