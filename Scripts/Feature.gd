extends GraphNode

@export(NodePath) onready var more = get_node(more) as VBoxContainer

@export(NodePath) onready var money = get_node(money) as HBoxContainer

@export(NodePath) onready var save_var = get_node(save_var) as HBoxContainer
@export(NodePath) onready var task = get_node(task) as HBoxContainer
@export(NodePath) onready var end = get_node(end) as HBoxContainer
@export(NodePath) onready var skills = get_node(skills) as HBoxContainer
@export(NodePath) onready var signal_emit = get_node(signal_emit) as HBoxContainer
@export(NodePath) onready var node_title =  get_node(node_title) as LineEdit

@onready var main = $HBoxContainer/MainColumn

var save_var_list = ["SaveVar"]
var node_type = "Feature"
var save_var_count = 0

var feature_title

func _on_GraphNode_resize_request(new_minsize):
	size = new_minsize

func _on_GraphNode_close_request():
	queue_free()



func _on_Skills_toggled(button_pressed):
	if button_pressed:
		skills.visible = true
	else:
		skills.visible = false



func _on_Task_toggled(button_pressed):
	if button_pressed:
		task.visible = true
	else:
		task.visible = false


func _on_SaveVar_toggled(button_pressed):
	if button_pressed:
		for save_var in save_var_list:
			main.get_node(save_var).visible = true
			save_var_count += 1
	else:
		for save_var in save_var_list:
			main.get_node(save_var).visible = false
			save_var_count -= 1


func _on_More_toggled(button_pressed):
	var add_column = $HBoxContainer/AddColumn
	
	if button_pressed:
		add_column.visible = true
	else:
		add_column.visible = false


func _on_new_save_var_button_pressed():
	var new_save_var = load("res://SaveVar.tscn")
	new_save_var = new_save_var.instantiate()
	$HBoxContainer/MainColumn.add_child(new_save_var)
	
	new_save_var.name = "SaveVar" + str(save_var_count)
	
	save_var_list.append(new_save_var.name)
	
	save_var_count += 1


func _on_EmitSignal_toggled(button_pressed):
	if button_pressed:
		signal_emit.visible = true
	else:
		signal_emit.visible = false
			


func _on_Money_toggled(button_pressed):
	if button_pressed:
		money.visible = true
	else:
		money.visible = false


func _on_LineEdit_text_changed(new_text):
	name = "FEATURE_" + new_text
	title = "FEATURE_" + new_text


func _on_End_toggled(button_pressed):
	if button_pressed:
		end.visible = true
	else:
		end.visible = false
