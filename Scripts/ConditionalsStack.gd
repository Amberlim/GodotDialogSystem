extends VBoxContainer

@export(NodePath) onready var skill  = get_node(skill) as HBoxContainer
@export(NodePath) onready var stack_index  = get_node(stack_index) as Label

var variable_count = 0
var brownie_count = 0
var visited_count = 0
var selected_conditional 

var conditionals_var = []
var conditionals_brownie = []
var conditionals_visited = []

func _on_Conditionals_item_selected(index):
	selected_conditional = index

func _on_Button_pressed():
	if selected_conditional == 0: #skill
		skill.visible = true
	elif selected_conditional == 1: #global var
		var new_var = load("res://ConditionalsStacks/ConditionalsVar.tscn")
		new_var = new_var.instantiate()
		add_child(new_var)
		new_var.name = "NewVar" + str(variable_count)
		variable_count += 1
		conditionals_var.append(new_var.name)
#		print("Variables: " + str(variable_count))
	elif selected_conditional == 2: #visited
		var new_visited = load("res://ConditionalsStacks/ConditionalsVisited.tscn")
		new_visited = new_visited.instantiate()
		add_child(new_visited)
		new_visited.name = "NewVisited" + str(visited_count)
		visited_count += 1
		conditionals_visited.append(new_visited.name)
#		print("Visited: " + str(visited_count))
	elif selected_conditional == 3: #brownie 
		var new_brownie = load("res://ConditionalsStacks/ConditionalsBrowniePoints.tscn")
		new_brownie = new_brownie.instantiate()
		add_child(new_brownie)
		new_brownie.name = "NewBrownie" + str(brownie_count)
		brownie_count += 1
#		print("Brownie NPCs: " + str(brownie_count))
