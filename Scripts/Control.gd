extends Control

var dialog = {}
var dialog_for_localisation = []

@export var file_path: String

@onready var sentence_node = preload("res://Objects/SentenceNode.tscn")
@onready var dice_roll_node = preload("res://Objects/DiceRoll.tscn")
@onready var choice_node = load("res://Objects/ChoiceNode.tscn")
@onready var root_node = load("res://Objects/RootNode.tscn")

@onready var graph_edit = $VBoxContainer/GraphEdit
@onready var timer = $Timer

var initial_pos = Vector2(40,40)
var option_index = 0
var node_index = 0
var all_nodes_index = 0

func _ready():
	if not file_path.is_empty():
		load_save()
	
	var new_root_node = root_node.instantiate()
	graph_edit.add_child(new_root_node)

	
# ADD NEW NODE
func _on_Button_pressed():
	
	# update node count
	all_nodes_index += 1
	node_index += 1
	# node_count.text = "Node Count: " + str(node_index)
	
	# instance node
	var node = sentence_node.instantiate()
	graph_edit.add_child(node)
	
	# graph offset
#	node.offset += initial_pos + (node_index * Vector2(5,5))
	
	# autosave everytime a new node is instanced
#	_on_RunProgram_pressed(0)
	
# SAVE 
func _on_RunProgram_pressed(): 
	
	# extract data from nodes
#	for node in range(0, connection_list.size()):
	for node in get_tree().get_nodes_in_group("graph_nodes"):
		
		var dialog_template = {}
		var localise_dialog = {}
		
		# name the node
		dialog[node.title] = dialog_template
		dialog_template["id"] = node.title
		
		# offset
		dialog_template["offset x"] = node.offset.x
		dialog_template["offset y"] = node.offset.y
		
		# go to
		dialog_template["go to"] = []
		for connection in graph_edit.get_connection_list():
			if connection["from"] == node.name:
				dialog_template["go to"].append(connection["to"])		

		# dice roll
		if node.node_type == "Dice Roll":
			
			dialog_template["node type"] = node.node_type
			dialog_template["dice skill"] = node.skill.text
			dialog_template["dice target"] = node.target_number.value
			
			# BREAKDOWN of connections
		#	["from"] = node.name # from current node
		#	["from port"] = option_count # from current option port
		#	["to"] = data[node_index]["go to"][option_count - 1] # connect to node
		#	["to port"] = 0 # connect to text port
	
		elif node.node_type == "Feature":
			# money 	
			if node.money.visible:
				dialog_template["money"] = node.money.get_node("Spinbox").value
				
			if node.end.visible:
				dialog_template["emit signal"] = "dialog_end"
			
			# save global variables
			if node.save_var.visible:
				for save_var in node.save_var_list:
					save_var = node.main.get_node(save_var)
					var variable_in_question = save_var.get_node("LineEdit").text
					
					# record purposes
					dialog_template[variable_in_question] = save_var.get_node("CheckButton").pressed
					
					# auto save variables to game save
					GameSave.variables[variable_in_question] = save_var.get_node("CheckButton").pressed
					
					# save game
					
			if node.task.visible:
				# record purposes
				dialog_template["task"] = node.task.get_node("LineEdit").text
			if node.skills.visible:
				dialog_template["skill lvl up"] = {}
				var dict_key = node.skills.get_node("HBoxContainer/SkillOption").text
				var dict_value = node.skills.get_node("HBoxContainer/SkillUpgrade").value
				
				dialog_template["skill lvl up"][dict_key] = dict_value
				
			if node.signal_emit.visible:
				dialog_template["emit signal"] = node.signal_emit.get_node("LineEdit").text
	
		elif node.node_type == "Option":
			dialog_template["node type"] = node.node_type
			
			# dialog text	
			var option_text = node.get_node("HBoxContainer/MainColumn/Text/TextEdit").text
			
			if option_text != "":
				dialog_template["text"] = option_text
			
		else:
			
			dialog_template["character"] = node.character.get_node("CharacterDrop").text
			
			if node.display_name.visible:
				dialog_template["display name"] = node.display_name.get_node("LineEdit").text
				
			if node.line_asset.visible:
				dialog_template["line asset"] = node.line_asset.get_node("LineEdit").text
			
			# dialog text	
			var dialog_text = node.get_node("HBoxContainer/MainColumn/Text/TextEdit").text
			
			if dialog_text != "":
				dialog_template["text"] = dialog_text
			
	#		print(dialog_text) #for localisation
				
			# conditionals
			if node.stack_count > 0 :
				dialog_template["conditionals"] = []
				
				for if_stack in node.conditionals_list: # loop through all stacks
					var stack = node.main.get_node(if_stack)
					var one_stack = {} # save each stack data as dictionary
					
					# if conditional variables exist
					if stack.variable_count > 0:
						var if_var_stack = {}
						var var_count = 0
						
						for var_stack in stack.conditionals_var: # for each variable
							var_stack = stack.get_node(var_stack)
							
							if_var_stack[var_stack.get_node("HBoxContainer/GlobalVar").text] = var_stack.get_node("HBoxContainer/CheckButton").pressed
							
							var_count += 1
							
						one_stack["if var"] = if_var_stack
							
						
					# skills
					var conditionals_skills = stack.get_node("ConditionalsSkill")
					if conditionals_skills.visible:
						one_stack["if skill"] = {}
						var if_skill_stack = {}
						
						if_skill_stack[conditionals_skills.get_node("HBoxContainer/SkillOption").text] = conditionals_skills.get_node("HBoxContainer/SkillPoints").text
						
						one_stack["if skill"] = if_skill_stack
						
					# if visited
					if stack.visited_count > 0:
						var if_visited_stack = {}
						
						for visited_stack in stack.conditionals_visited: # for each variable
							visited_stack = stack.get_node(visited_stack)
							
							if_visited_stack[visited_stack.get_node("HBoxContainer/VisitedNode").value] = visited_stack.get_node("HBoxContainer/VisitedIndex").value
							
						one_stack["if visited"] = if_visited_stack
						
					
					# brownie
					if stack.brownie_count > 0:
						var if_brownie_stack = {}
						
						for brownie_stack in stack.conditionals_brownie:
							brownie_stack = stack.geT_node(brownie_stack)
							
							if_brownie_stack[brownie_stack.get_node("HBoxContainer/NPC").text] = [brownie_stack.get_node("HBoxContainer/BrowniePoints").value]
							
						one_stack["if brownie"] = if_brownie_stack	
							
					# append  one stack as a dictionary		
					dialog_template["conditionals"].append(one_stack)
				
			# go to
			dialog_template["go to"] = []
			for connection in graph_edit.get_connection_list():
				if connection["from"] == node.name:
					dialog_template["go to"].append(connection["to"])		
					
		# append to dictionary
		dialog[node.title] = dialog_template
		
	# save node and option count
	dialog["all_nodes_index"] = all_nodes_index
	dialog["option_index"] = option_index
	dialog["node_index"] = node_index
	
	var time = Time.get_datetime_dict_from_system()
	var year = str(time["year"])
	var month = str(time["month"])
	var day = str(time["day"])
	var hour = str(time["hour"])
	var minute = str(time["minute"])
	var file_path = day + "." + month + "." + year + "_" + hour + minute
	
	save_dialog(file_path)
	
func save_dialog(file_path):
	# save file
	file_path = "user://" + file_path
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_line(JSON.new().stringify(dialog))
	file.close()
	
	$HBoxContainer/Notification.visible = true
	timer.start()
	await timer.timeout
	$HBoxContainer/Notification.visible = false
	
	
	
func load_save():
	var file = FileAccess.open("user://" + file_path, FileAccess.READ)

	if not FileAccess.file_exists("user://" + file_path):
		save_dialog(file_path)
		OS.alert("New file is created.")
		return

	var data = file.get_as_text()
	var test_json_conv = JSON.new()
	test_json_conv.parse(data)
	data = test_json_conv.get_data()
	file.close()

	# load node and option count
	all_nodes_index = data.get("all_nodes_index") if data.has("all_nodes_index") else 0
	option_index = data.get("option_index") if data.has("option_index") else 0
	node_index = data.get("node_index") if data.has("node_index") else 0
	
	# option_count.text = "Option Count: " + str(option_index)
	# node_count.text = "Node Count: " + str(node_index)
	
	for graph_node in data:
		
		# ignore index counts
		if not "index" in graph_node:
			
			var node
			
			if "OPTION" in graph_node:
				print("OPTION")
				# instance node
				node = load("res://OptionNode.tscn")
				node = node.instantiate()
				graph_edit.add_child(node)
				
				if "dice skill" in graph_node: 	node.dice.get_node("SkillOption").text = data[graph_node]["dice skill"]
					
				if "text" in data[graph_node]:
					node._on_Text_toggled(true)
					node.text.get_node("TextEdit").text = data[graph_node]["text"]

			elif "DICEROLL" in graph_node:
				print("DICEROLL")
				node = load("res://DiceRoll.tscn")
				node = node.instantiate()
				graph_edit.add_child(node)
				
				node.skill.text = data[graph_node]["dice skill"]
				node.target_number.value = data[graph_node]["dice target"]
				
			elif "FEATURE" in graph_node:
				print("FEATURE")
				# instance node
				node = load("res://Feature.tscn")
				node = node.instantiate()
				graph_edit.add_child(node)
				
				if "save var" in data[graph_node]:
					node._on_SaveVar_toggled(true)
					var save_var_count = data[node_index]["save var"].size()
					var var_count = 0
					for variable in data[node_index]["save var"]:
						if var_count == 0:

							node.emit_signal("toggled", true)
							# get key as string
							var key_name = data[node_index]["save var"].keys()
							key_name = key_name[var_count]

							node.save_var.get_node("LineEdit").text = key_name

							node.save_var.get_node("CheckButton").button_pressed = data[node_index]["save var"][key_name]

						else:
							node._on_new_save_var_button_pressed()
							var new_var = node.main.get_node("SaveVar" + str(var_count))

							# get key as string
							var key_name = data[node_index]["save var"].keys()
							key_name = key_name[var_count]

							new_var.get_node("LineEdit").text = key_name
							new_var.get_node("CheckButton").button_pressed = data[node_index]["save var"][key_name]

						var_count += 1

				if "money" in data[graph_node]:
					node._on_Money_toggled(true)
					node.money.get_node("Spinbox").value = data[graph_node]["money"]
					
				if "task" in data[graph_node]:
					node._on_Task_toggled(true)
					node.task.get_node("LineEdit").text = data[graph_node]["task"]
				
				if "emit signal" in data[graph_node]:
					if data[graph_node]["emit signal"] == "dialog_end":
						node._on_End_toggled(true)
					else:
						node._on_EmitSignal_toggled(true)
						node.signal_emit.get_node("LineEdit").text = data[graph_node]["emit signal"]		
				
				if "skill lvl up" in data[graph_node]:
					node._on_Skills_toggled(true)
					var skill_option = node.skills.get_node("HBoxContainer").get_node("SkillOption")
					var skill_upgrade = node.skills.get_node("HBoxContainer").get_node("SkillUpgrade")

					var skill_key = data[graph_node]["skill lvl up"].keys()
					skill_option.text = skill_key[0]
					skill_upgrade.value = int(data[graph_node]["skill lvl up"][skill_key[0]])
			
			elif "NODE" in graph_node:
				print("NODE" + graph_node)
				# instance node
				node = load("res://GraphNode.tscn")
				node = node.instantiate()
				graph_edit.add_child(node)


				node.character.get_node("CharacterDrop").text = data[graph_node]["character"]
				
				if "display name" in data[graph_node]:
					node._on_DisplayName_toggled(true)
					node.display_name.get_node("LineEdit").text = data[graph_node]["display name"]
					

				if "line asset" in data[graph_node]:
					node._on_LineAsset_toggled(true)
					node.line_asset.get_node("LineEdit").text = data[graph_node]["line asset"]	

				if "text" in data[graph_node]:
					node._on_Text_toggled(true)
					node.text.get_node("TextEdit").text = data[graph_node]["text"]

				# conditionals
				if "conditionals" in data[graph_node]:
					
					for stack in data[graph_node]["conditionals"]: #get each stack
						# create a new if stack
						node._on_Conditional_pressed()

						if "if var" in stack:
							var if_var_count = 0
							
							for each_var in stack["if var"]: #get each var (from file)
								# create a new var
								node.if_stack.selected_conditional = 1 
								node.if_stack._on_Button_pressed()

								# get new var node 
								var new_var_node = node.if_stack.get_node("NewVar"+str(if_var_count))
								
								# reassign values
								new_var_node.get_node("HBoxContainer/GlobalVar").text = each_var
								
								new_var_node.get_node("HBoxContainer/CheckButton").button_pressed = stack["if var"][each_var]

								# keep count
								if_var_count += 1
						
						if "if visited" in stack:
							var if_visited_count = 0
							
							for each_visited in stack["if visited"]: #get each visited (from file)
								# create a new visited 
								node.if_stack.selected_conditional = 2
								node.if_stack._on_Button_pressed()

								# get new var visited 
								var new_visited_node = node.if_stack.get_node("NewVisited"+str(if_visited_count))
								
								# reassign values
								new_visited_node.get_node("HBoxContainer/VisitedNode").value = int(each_visited)
								
								new_visited_node.get_node("HBoxContainer/VisitedIndex").value = stack["if visited"][each_visited]

								# keep count
								if_visited_count += 1

						if "if brownie" in stack:
							var if_brownie_count = 0
							
							for each_brownie in stack["if brownie"]: #get each brownie (from file)
								# create a new brownie
								node.if_stack.selected_conditional = 3
								node.if_stack._on_Button_pressed()

								# get new var node 
								var new_brownie_node = node.if_stack.get_node("NewBrownie"+str(if_brownie_count))
								
								# reassign values
								new_brownie_node.get_node("HBoxContainer/NPC").text = each_brownie
								
								new_brownie_node.get_node("HBoxContainer/BrowniePoints").value = stack["if brownie"][each_brownie]

								# keep count
								if_brownie_count += 1

						if "if skill" in stack:
							# create a new skill
							node.if_stack.selected_conditional = 0
							node.if_stack._on_Button_pressed()
						
							# get skill node
							var skill_node = node.if_stack.get_node("ConditionalsSkill/HBoxContainer")
							var skill_key = stack["if skill"].keys()
							
							# reassign values
							skill_node.get_node("SkillOption").text = skill_key[0]
							skill_node.get_node("SkillPoints").text = stack["if skill"][skill_key[0]]

			# node name
			node.name = data[graph_node]["id"]
			node.title = data[graph_node]["id"]
			node.node_title.text = node.name

			if "go to" in data[graph_node]:
				
				if "DICEROLL" in graph_node:

					var go_to_count = 0
					
					for go_to in data[graph_node]["go to"]: # get each in array
						graph_edit.connect_node(node.name, go_to_count, data[graph_node]["go to"][go_to_count], 0)
						
						go_to_count += 1
				else:		
					var go_to_count = 0
					for go_to in data[graph_node]["go to"]: # get each in array
						graph_edit.connect_node(node.name, 0, data[graph_node]["go to"][go_to_count], 0)
						
						go_to_count += 1
						
			
			# node offset
			# offset
			node.offset.x = data[graph_node]["offset x"]
			node.offset.y = data[graph_node]["offset y"]
			initial_pos = node.offset		

func _on_NewOption_pressed():
	var new_choice_node = choice_node.instantiate()
	graph_edit.add_child(new_choice_node)

# connect nodes
func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graph_edit.connect_node(from, from_slot, to, to_slot)

func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	graph_edit.disconnect_node(from, from_slot, to, to_slot)

func _on_Clear_pressed():
	for node in get_tree().get_nodes_in_group("graph_nodes"):
		node.queue_free()
	graph_edit.clear_connections()
	
	node_index = 0
	all_nodes_index = 0
	# option_count = 0


func _on_GraphEdit_gui_input(event):
	if Input.is_action_pressed("right_click"):
		_on_Button_pressed()
	elif event is InputEventMouseButton and false:
		_on_NewOption_pressed()
	elif Input.is_action_pressed("save"):
		_on_RunProgram_pressed()
	elif Input.is_action_just_pressed("new_option"):
		_on_NewOption_pressed()


func _on_NewRoll_pressed():
	var dice_roll = dice_roll_node.instantiate()
	graph_edit.add_child(dice_roll)	
