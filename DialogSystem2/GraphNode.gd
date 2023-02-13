extends GraphNode

export(NodePath) onready var comment_box = get_node(comment_box) as HBoxContainer
export(NodePath) onready var main = get_node(main) as VBoxContainer
export(NodePath) onready var more = get_node(more) as VBoxContainer
export(NodePath) onready var text = get_node(text) as HBoxContainer
export(NodePath) onready var display_name = get_node(display_name) as HBoxContainer
export(NodePath) onready var node_title =  get_node(node_title) as LineEdit

export(NodePath) onready var character = get_node(character) as HBoxContainer
export(NodePath) onready var character_drop = get_node(character_drop) as OptionButton

export(NodePath) onready var line_asset = get_node(line_asset) as HBoxContainer

var if_stack

# edit character drop down items
#var profiles = ["Raymond", "Mable", "???", "Ren", "Narration", "Uncle Ping"]
var profiles = ["Santa", "Elf"]

var stack_count = 0
var save_var_count = 0
var conditionals_list = []
var save_var_list = ["SaveVar"]
var node_type = "Node"

func _ready():
	var profile_index = 0
	for profile in profiles:
		character_drop.add_item(profile, profile_index)
		profile_index += 1 

func _on_GraphNode_resize_request(new_minsize):
	rect_size = new_minsize

func _on_GraphNode_close_request():
	# if last node is deleted, replace that node index and name
	if get_parent().get_parent().node_index == (int(self.name.lstrip("Node "))):
		get_parent().get_parent().node_index -= 1
	queue_free()




func _on_Conditional_pressed():
	var conditionals_stack = load("res://ConditionalsStack.tscn")
	conditionals_stack = conditionals_stack.instance()
	main.add_child(conditionals_stack)
	
	stack_count += 1
	
	if stack_count >= 2: 
		conditionals_stack.stack_index.text = "OR"
		
	conditionals_stack.name = "IfStack" + str(stack_count)
	conditionals_list.append(conditionals_stack.name)
	
	if_stack = conditionals_stack
	


func _on_DisplayName_toggled(button_pressed):
	if button_pressed:
		display_name.visible = true
	else:
		display_name.visible = false


func _on_Comment_toggled(button_pressed):
	if button_pressed:
		comment_box.visible = true
	else:
		comment_box.visible = false





func _on_More_toggled(button_pressed):
	var add_column = $HBoxContainer/AddColumn
	
	if button_pressed:
		add_column.visible = true
	else:
		add_column.visible = false



func _on_LineAsset_toggled(button_pressed):
	if button_pressed:
		line_asset.visible = true
	else:
		line_asset.visible = false



func _on_Text_toggled(button_pressed):
	if button_pressed:
		text.visible = true
	else:
		text.visible = false


			


func _on_LineEdit_text_changed(new_text):
	name = "NODE_" + new_text
	title = "NODE_" + new_text
