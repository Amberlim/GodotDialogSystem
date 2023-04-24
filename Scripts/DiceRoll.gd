extends GraphNode

var node_type = "Dice Roll"

@onready var skill = $VBoxContainer/Skill/OptionButton
@onready var target_number = $VBoxContainer/Target/TargetNumber
@onready var node_title: LineEdit = $VBoxContainer/Title/LineEdit


func _on_LineEdit_text_changed(new_text):
	title = "DICEROLL_" + new_text
	name = "DICEROLL_" + new_text
