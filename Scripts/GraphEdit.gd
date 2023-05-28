extends GraphEdit


var speakers = []


func _ready():
	update_speakers()


func get_all_connections_from_node(from_node: StringName):
	var connections = []
	
	for connection in get_connection_list():
		if connection.get("from") == from_node:
			var to = get_node_or_null(NodePath(connection.get("to")))
			connections.append(to)

	return connections


func get_all_connections_from_slot(from_node: StringName, from_port: int):
	var connections = []
	
	for connection in get_connection_list():
		if connection.get("from") == from_node and connection.get("from_port") == from_port:
			var to = get_node_or_null(NodePath(connection.get("to")))
			connections.append(to)

	return connections


func update_speakers(characters: Array = []):
	speakers.clear()
	
	speakers.append("_NARRATOR")
	for speaker in characters:
		if speaker.get("ID") != "":
			speakers.append(speaker.get("ID"))
	
	for node in get_children():
		if node.node_type == "NodeSentence":
			var selected = node.character_drop.selected
			node.character_drop.clear()
			for speaker in speakers:
				node.character_drop.add_item(speaker)
			node.character_drop.select(selected)
			
