extends PanelContainer


@onready var label = $LabelContainer/Label

var id = UUID.v4()


func set_label(text):
	label.text = text
