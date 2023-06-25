extends GraphNode


var _node_dict: Dictionary

var id = UUID.v4()
var node_type = "NodeDiceRoll"
var target_number = 0
var actions: Array

func _ready():
	title = node_type


func _to_dict() -> Dictionary:
	var pass_id_node = get_parent().get_all_connections_from_slot(name, 0)
	var fail_id_node = get_parent().get_all_connections_from_slot(name, 1)
	
	return {
		"$type": node_type,
		"ID": id,
		"Skill": "",
		"Target": target_number,
		"PassID": pass_id_node[0].id if pass_id_node else -1,
		"FailID": fail_id_node[0].id if fail_id_node else -1,
		"Conditions": [],
		"Actions": actions,
		"Flags": [],
		"CustomProperties": [],
		"EditorPosition": {
			"x": position_offset.x,
			"y": position_offset.y
		}
	}


func _from_dict(dict):
	_node_dict = dict
	
	id = dict.get("ID")
	target_number = dict.get("Target")
	actions = dict.get("Actions")
	
	position_offset.x = dict.EditorPosition.get("x")
	position_offset.y = dict.EditorPosition.get("y")


func _on_close_request():
	queue_free()
	get_parent().clear_all_empty_connections()
