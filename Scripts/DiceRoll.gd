extends GraphNode


@onready var target_number = $VBoxContainer/HBoxContainer2/TargetNumber

var node_type = "NodeDiceRoll"
var id = UUID.v4()

func _ready():
	title = node_type + " (" + id + ")"


func _to_dict() -> Dictionary:
	return {
		"$type": node_type,
		"ID": id,
		"Skill": "",
		"Target": target_number.value,
		"PassID": 0,
		"FailID": 0,
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}
