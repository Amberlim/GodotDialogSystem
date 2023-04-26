extends GraphEdit


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
