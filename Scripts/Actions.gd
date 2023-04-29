extends PanelContainer


@onready var actions_container = $MarginContainer/VBoxContainer2/ActionsContainer
@onready var action_item_node = preload("res://Objects/ActionItem.tscn")


func _to_dict():
	var arr = []
	for action in actions_container.get_children():
		arr.append(action._to_dict())
	
	return arr

func new_action(action: String = "", argument: String = ""):
	var new_action = action_item_node.instantiate()
	actions_container.add_child(new_action)
	
	if action:
		var action_idx = new_action.get_action_idx_from_text(action)
		new_action.option_btn.select(action_idx)
	
	new_action.argument.text = argument

func _on_button_pressed():
	new_action()
