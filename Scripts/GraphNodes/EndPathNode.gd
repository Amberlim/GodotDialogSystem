extends GraphNode


var node_type = "EndPath"
var id = UUID.v4()
var actions: Array


func _ready():
	title = node_type + " (" + id +")"


func _to_dict():
	return {
		"$type": node_type,
		"ID": id,
		"Actions": actions,
		"Flags": [],
		"CustomProperties": [],
		"EditorPosition": {
			"x": position_offset.x,
			"y": position_offset.y
		}
	}


func _from_dict(dict):
	id = dict.get("ID")


func _on_close_request():
	queue_free()
