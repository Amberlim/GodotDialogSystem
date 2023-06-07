extends GraphNode


@onready var target_number = $VBoxContainer/HBoxContainer2/TargetNumber
@onready var actions = $Actions

var node_type = "NodeDiceRoll"
var id = UUID.v4()

func _ready():
	title = node_type + " (" + id + ")"


func _to_dict() -> Dictionary:
	var pass_id_node = get_parent().get_all_connections_from_slot(name, 0)
	var fail_id_node = get_parent().get_all_connections_from_slot(name, 1)
	
	return {
		"$type": node_type,
		"ID": id,
		"Skill": "",
		"Target": target_number.value,
		"PassID": pass_id_node[0].id if pass_id_node else -1,
		"FailID": fail_id_node[0].id if fail_id_node else -1,
		"Conditions": [],
		"Actions": actions._to_dict(),
		"Flags": [],
		"CustomProperties": [],
		"EditorPosition": {
			"x": position_offset.x,
			"y": position_offset.y
		}
	}


func _on_close_request():
	queue_free()
