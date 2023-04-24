extends GraphNode

@onready var comment_box: HBoxContainer = $HBoxContainer/MainColumn/Comment
@onready var main: VBoxContainer = $HBoxContainer/MainColumn
@onready var more: VBoxContainer = $HBoxContainer/AddColumn
@onready var text: HBoxContainer =  $HBoxContainer/MainColumn/Text
@onready var display_name: HBoxContainer = $HBoxContainer/MainColumn/DisplayName
@onready var node_title: LineEdit = $HBoxContainer/MainColumn/Title/LineEdit
@onready var character: HBoxContainer = $HBoxContainer/MainColumn/Character
@onready var character_drop: OptionButton = $HBoxContainer/MainColumn/Character/CharacterDrop
@onready var line_asset: HBoxContainer = $HBoxContainer/MainColumn/LineAsset

@onready var conditionals_stack_node = load("res://Objects/ConditionalsStack.tscn")

var id = UUID.v4()

var if_stack
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
	
	title = node_type + " (" + id + ")"

func _on_GraphNode_resize_request(new_minsize):
	size = new_minsize

func _on_GraphNode_close_request():
	# if last node is deleted, replace that node index and name
	if get_parent().get_parent().node_index == (int(self.name.lstrip("Node "))):
		get_parent().get_parent().node_index -= 1
	queue_free()




func _on_Conditional_pressed():
	var conditionals_stack = conditionals_stack_node.instantiate()
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
