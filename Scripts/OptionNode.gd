extends PanelContainer


var id = UUID.v4()
var node_type = "NodeOption"


func _to_dict() -> Dictionary:
	return {
		"$type": node_type,
		"ID": id,
		"NextID": 0,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}
