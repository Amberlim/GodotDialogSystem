extends GraphNode

var node_type = "Option"

@export(NodePath) onready var comment_box = get_node(comment_box) as HBoxContainer

@export(NodePath) onready var main = get_node(main) as VBoxContainer
@export(NodePath) onready var more = get_node(more) as VBoxContainer
@export(NodePath) onready var text = get_node(text) as HBoxContainer
@export(NodePath) onready var node_title =  get_node(node_title) as LineEdit

var if_stack


var stack_count = 0
var save_var_list = ["SaveVar"]
var save_var_count = 0
var conditionals_list = []

func _on_OptionNode_resize_request(new_minsize):
	size = new_minsize

func _on_OptionNode_close_request():
	# if last node is deleted, replace that node index and name
	if get_parent().get_parent().node_index == (int(self.name.lstrip("Node "))):
		get_parent().get_parent().node_index -= 1
	queue_free()


func _on_LineEdit_text_changed(new_text):
	title = "OPTION_" + new_text
	name = "OPTION_" + new_text

func _on_Conditional_pressed():
	var conditionals_stack = load("res://ConditionalsStack.tscn")
	conditionals_stack = conditionals_stack.instantiate()
	main.add_child(conditionals_stack)
	
	stack_count += 1
	
	if stack_count >= 2: 
		conditionals_stack.stack_index.text = "OR"
		
	conditionals_stack.name = "IfStack" + str(stack_count)
	conditionals_list.append(conditionals_stack.name)
	
	if_stack = conditionals_stack
	

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


func _on_Text_toggled(button_pressed):
	if button_pressed:
		text.visible = true
	else:
		text.visible = false

