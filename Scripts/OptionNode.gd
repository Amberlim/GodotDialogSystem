extends GraphNode

var node_type = "Choice"

@onready var conditionals_stack = preload("res://Objects/ConditionalsStack.tscn")
@onready var option_panel = preload("res://Objects/OptionPanel.tscn")

var id = UUID.v4()

var if_stack

var stack_count = 0
var save_var_list = ["SaveVar"]
var save_var_count = 0
var conditionals_list = []


func _ready():
	_on_More_toggled()
	
	title = node_type + "Node (" + id + ")"


func _on_OptionNode_resize_request(new_minsize):
	size = new_minsize


func _on_OptionNode_close_request():
	queue_free()
	

func _on_More_toggled(button_pressed = null):
	var new_option = option_panel.instantiate()
	add_child(new_option)
	move_child($More, get_child_count()-1)
	if get_child_count()-2 <=0:
		set_slot(get_child_count()-2, true, 0, Color("ff2865"), true, 0, Color("097168"))
		return
	
	set_slot(get_child_count()-2, false, 0, Color("ff2865"), true, 0, Color("097168"))
