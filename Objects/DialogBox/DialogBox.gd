extends Control

signal timeline_end
@export var play_node: int 

# get node components
@export(NodePath) onready var portrait = get_node(portrait) as TextureRect
@export(NodePath) onready var ch_name = get_node(ch_name) as Label
@export(NodePath) onready var text = get_node(text) as RichTextLabel

# File paths
@export var portraits_folder # (String, DIR)

var dialog 

func _ready():
	load_dialog()
	play("Node 1")
	
func extract_node_number(node_name):
	return int(node_name.lstrip("Node "))
		
func load_dialog():
	var file = File.new()
	file.open("user://dialog_json", File.READ)
	dialog = file.get_as_text()
	var test_json_conv = JSON.new()
	test_json_conv.parse(dialog)
	dialog = test_json_conv.get_data()
	file.close()

func play(play_node: String):
	
	var current_dict
	
	for block in dialog:
		if block["id"] == play_node:
			current_dict = block
	
	
	print("Current node: " + current_dict["id"]) # debug
		
	
	# execute go-to only at the end of each dialog node
	var final_go_to_node_index : int
	var final_go_to_option_index = []
	
	# add node to visited
	GameSave.visited[current_dict["id"]]	+= 1
		

	if current_dict.has("go to"):
		
		# conditionals : multiple go-tos 
		if current_dict["go to"].size() > 1:
			for go_to in current_dict["go to"]: # each go to
				
				# get the node_index of the go_to node
				var node_number = extract_node_number(go_to)
				var go_to_node = dialog[node_number-1] # node index
				
				# if branches into options
				if go_to_node.has("node type") and go_to_node["node type"] == "Option":
					
					# check if options has conditionals
					if go_to_node.has("conditionals"):
					
						# check for conditions
						var conditions_fulfilled = check_for_conditionals(go_to_node)
						
						# if false, check the next go_to_option
						# if true, set to display that option
						if conditions_fulfilled: 
							final_go_to_option_index.append(node_number - 1)
									
					# if option doesn't have conditionals
					else:
						final_go_to_option_index.append(node_number - 1)
						
		
				else: # if branches into conditional nodes
				
					if go_to_node.has("conditionals"):
						# check for conditions
						var conditions_fulfilled = check_for_conditionals(go_to_node)
						
						# if false, check the next go_to_node
						# if true, play that node
						if conditions_fulfilled: 
							final_go_to_node_index = node_number - 1
							break						
					# if node doesn't have conditionals
					else:
						final_go_to_node_index = node_number - 1
						
		# simple go-to : one go-to and no options
		elif current_dict["go to"].size() == 1:
			var go_to_node = extract_node_number(current_dict["go to"][0]) - 1
			
			final_go_to_node_index = go_to_node
			
	else:
		# end dialog : play end animation, emit signal
		emit_signal("timeline_end")
				
	if current_dict.has("save var"):
		for save_var_key in current_dict["save var"]:
			GameSave.variables[save_var_key] = current_dict["save var"][save_var_key]
			
	if current_dict.has("text"):
		text.text = current_dict["text"]
			
	# NODE TYPE: Default
	if current_dict.has("character"):
		
		# set label text
		ch_name = current_dict["character"] + ", " + Profiles.character[current_dict["character"]]
		
		# set character portrait
		portrait.texture = load(portraits_folder + "/" + current_dict["character"])
		
	if current_dict.has("display name"):
		# set label text
		ch_name = current_dict["display name"] 
		
	if current_dict.has("task"):
		pass
		
		# task splash
		
	if current_dict.has("emit signal"):
		get_tree().current_scene.emit_signal(current_dict["emit_signal"])
		
	if current_dict.has("skill lvl up"):
		
		var skill = current_dict["skill lvl up"].keys()
		skill = skill[skill.size() - 1]
		
		# update stats
		GameSave.skills[skill] = current_dict["skill lvl up"][skill]
		
		# splash level up		
			
	if current_dict.has("line asset"):
		pass
	
	if current_dict.has("go to"):
		if final_go_to_option_index.is_empty():
			continue_dialog(final_go_to_node_index)
		else: # options
			continue_dialog(final_go_to_option_index, "Options")
		
func check_for_conditionals(current_dict):
	var stack_keys = current_dict["conditionals"]
	var stack_fulfilled 
	  
	var stack_index = 0 
	
	for stack in current_dict["conditionals"]:  # each stack
		
		print ("STACK " + str(stack_index) + ":") # debug
		
		stack_fulfilled = false
		
		if stack_keys.has("if var"):
			for if_var in stack_keys["if var"]:
				if GameSave.variables.has(if_var):
					if GameSave.variables[if_var] == stack_keys["if var"][if_var]:
						stack_fulfilled = true
						
						print(stack_keys["if var"][if_var] + " = true") # debug
					else:
						stack_fulfilled = false
						print(stack_keys["if var"][if_var] + " = false") # debug
			  
		if stack_keys.has("if skill"):
			for if_skill in stack_keys["if skill"]:
				
				# bigger than
				if stack_keys["if skill"][if_skill].has(">"):
					if GameSave.skills[if_skill] >= stack_keys["if skill"][if_skill]:
						stack_fulfilled = true
						
						print(stack_keys["if skill"][if_skill] +" is greater than = true") # debug
						
					else: 
						stack_fulfilled = false
						
						print(stack_keys["if skill"][if_skill] +" is greater than = false") # debug
				# less than
				if stack_keys["if skill"][if_skill].has("<"):
					if GameSave.skills[if_skill] <= stack_keys["if skill"][if_skill]:
						stack_fulfilled = true
						print(stack_keys["if skill"][if_skill] +" is less than = true") # debug
					else: 
						stack_fulfilled = false
						print(stack_keys["if skill"][if_skill] +" is less than = false") # debug
						
				else: # equals to
					if GameSave.skills[if_skill] == stack_keys["if skill"][if_skill]:
						stack_fulfilled = true
						print(stack_keys["if skill"][if_skill] + " is equal to = true") # debug
					else: 
						stack_fulfilled = false
						print(stack_keys["if skill"][if_skill] + " sis equal to = false") # debug
			  
			  
		if stack_keys.has("if visited"):
			for if_visited in stack_keys["if visited"]:
				if GameSave.visited[if_visited] == stack_keys["if visited"][if_visited]:
					stack_fulfilled = true
					print(stack_keys["if visited"][if_visited] + " visited = true") # debug
				else: 
					stack_fulfilled = false
					print(stack_keys["if visited"][if_visited] + " visited = false") # debug
		  
		
		if stack_keys.has("if npc brownie"):
			for if_brownie in stack_keys["if brownie"]:
				if GameSave.brownies[if_brownie] == stack_keys["if brownie"][if_brownie]:
					stack_fulfilled = true
					
					print( str(stack_keys["if brownie"][if_brownie]) + " brownie points = true") # debug
					
				else: 
					stack_fulfilled = false
					print( str(stack_keys["if brownie"][if_brownie]) + " brownie points = false") # debug
			
		# if a stack is fulfilled, break, but if not, continue looping through the stacks. If none of the stacks are fulfilled, go to the next node (+1)
		if stack_fulfilled:
			break
			print("Stack index " + str(stack_index) + " fulfilled.") # debug
		  
	if stack_fulfilled:
		# play node 
		return true
	else:
		# do NOT play node, go to the next node 
		return false		
		print("Stack index " + str(stack_index) + " NOT fulfilled.") # debug

func continue_dialog(next_node_index_to_play, node_type = "Default"):
	var vbox_container = $VBoxContainer
	
	# continue button appears
	var continue_button = load("res://DialogBox/Continue.tscn")
	continue_button = continue_button.instantiate()
	vbox_container.add_child(continue_button)
	
	await continue_button.pressed
	
	# upon pressing continue button
	if node_type == "Default":
		play(next_node_index_to_play)
		
	elif node_type == "Options":
		
		for node in next_node_index_to_play:
			
			# instance valid options
			var option = load("res://DialogBox/Option.tscn")
			option = option.instantiate()
			vbox_container.add_child(option)
			
			# set option data
			option.text = dialog[node]["text"]
			option.node_index = node
			
			# assign custom signal for option selection
			option.connect("option_pressed", Callable(self, "go_to_selected_node"))
			
func go_to_selected_node(option_go_to_index):	
	# go to option's node index
	play(option_go_to_index)



	
