extends GraphNode

var node_type = "Option"

@onready var text = $Title/LineEdit

@onready var conditionals_stack = preload("res://Objects/ConditionalsStack.tscn")
@onready var option_panel = preload("res://Objects/OptionPanel.tscn")

var if_stack

var stack_count = 0
var save_var_list = ["SaveVar"]
var save_var_count = 0
var conditionals_list = []


func _ready():
	_on_More_toggled()


func _on_OptionNode_resize_request(new_minsize):
	size = new_minsize


func _on_OptionNode_close_request():
	queue_free()


func _on_LineEdit_text_changed(new_text):
	title = "OPTION_" + new_text
	name = "OPTION_" + new_text
	

func _on_More_toggled(button_pressed = null):
	var new_option = option_panel.instantiate()
	add_child(new_option)
	move_child($More, get_child_count()-1)
	set_slot(get_child_count()-2, false, 1, Color(1, 0, 0, 0), true, 1, Color(0, 1, 0, 1))


func _on_Text_toggled(button_pressed):
	if button_pressed:
		text.visible = true
	else:
		text.visible = false

