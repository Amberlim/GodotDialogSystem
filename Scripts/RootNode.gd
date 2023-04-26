extends GraphNode


var id = UUID.v4()
var node_type = "Root"


func _ready():
	title = node_type + "Node (" + id + ")"


func _to_dict() -> Dictionary:
	return {
		"$type": "NodeRoot",
		"ID": id,
		"NextID": get_next_id(),
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func get_next_id():
	var parent: GraphEdit = get_parent()
	
	for connection in parent.get_connection_list():
		if connection.get("from") == "RootNode":
			var to = parent.get_node_or_null(NodePath(connection.get("to")))
			return to.id
