extends GraphNode


@onready var text: HBoxContainer = $MarginContainer/MainColumn/Text
@onready var display_name: HBoxContainer = $MarginContainer/MainColumn/VBoxContainer/MarginContainer/DisplayName
@onready var character_drop: OptionButton = $MarginContainer/MainColumn/VBoxContainer/Character/CharacterDrop


var id = UUID.v4()
var loaded_text = ""

var if_stack
var profiles = ["Santa", "Elf"]

var conditionals_list = []
var node_type = "NodeSentence"

func _ready():
	title = node_type + " (" + id + ")"

	if loaded_text:
		text.get_node("TextEdit").text = loaded_text

func _to_dict() -> Dictionary:
	var next_id_node = get_parent().get_all_connections_from_slot(name, 0)
	
	return {
		"$type": node_type,
		"ID": id,
		"NextID": next_id_node[0].id if next_id_node else -1,
		"Sentence": text.get_node("TextEdit").text,
		"SpeakerID": character_drop.get_item_text(character_drop.selected),
		"DisplaySpeakerName": "",
		"Conditions": [],
		"Actions": [],
		"Flags": [],
		"CustomProperties": []
	}


func _on_GraphNode_close_request():
	queue_free()


func get_character_idx_from_text(text: String):
	for idx in character_drop.item_count:
		var character = character_drop.get_item_text(idx)
		if character == text:
			return idx
	
	return 0
