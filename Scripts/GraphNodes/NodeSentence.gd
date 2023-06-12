extends GraphNode


var _node_dict: Dictionary

var id = UUID.v4()
var node_type = "NodeSentence"
var loaded_text = ""
var sentence = ""
var speaker_id = 0
var display_speaker_name = ""
var actions: Array


func _ready():
	title = node_type + " (" + id + ")"
	update_preview()


func _to_dict() -> Dictionary:
	var next_id_node = get_parent().get_all_connections_from_slot(name, 0)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Sentence": sentence,
		"SpeakerID": speaker_id,
		"DisplaySpeakerName": display_speaker_name,
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
	sentence = dict.get("Sentence")
	speaker_id = dict.get("SpeakerID")
	display_speaker_name = dict.get("DisplaySpeakerName")
	actions = dict.get("Actions")
	
	position_offset.x = dict.EditorPosition.get("x")
	position_offset.y = dict.EditorPosition.get("y")
	
	update_preview()


func update_preview():
	$MainContainer/TextLabelPreview.text = sentence


func _on_GraphNode_close_request():
	queue_free()
	get_parent().clear_all_empty_connections()
