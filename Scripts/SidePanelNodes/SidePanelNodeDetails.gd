extends PanelContainer


@onready var label_id = $MarginContainer/PanelContainer/LabelID
@onready var panel_container = $MarginContainer/PanelContainer

@onready var root_node_panel_instance = preload("res://Objects/SidePanelNodes/RootNodePanel.tscn")
@onready var sentence_node_panel_instance = preload("res://Objects/SidePanelNodes/SentenceNodePanel.tscn")

var selected_node = null
var current_panel = null

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func _on_graph_edit_node_selected(node):
	if current_panel:
		current_panel.queue_free()
		current_panel = null
	
	label_id.text = node.id
	selected_node = node
	
	var new_panel = null
	match selected_node.node_type:
		"NodeRoot":
			new_panel = root_node_panel_instance.instantiate()
		"NodeSentence":
			new_panel = sentence_node_panel_instance.instantiate()
		"NodeChoice": # TODO
			new_panel = null
	
	new_panel.graph_node = node
	
	if new_panel:
		current_panel = new_panel
		panel_container.add_child(new_panel)
		new_panel._from_dict(node._node_dict)
		
	show()


func _on_texture_button_pressed():
	hide()
