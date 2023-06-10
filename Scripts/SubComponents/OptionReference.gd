extends PanelContainer


@onready var option = $MainContainer/VBoxContainer/Option
@onready var sentence_preview = $MainContainer/VBoxContainer/SentencePreview

var id = UUID.v4()


func _ready():
	var index = get_parent().get_children().find(self) + 1
	option.text = "Option " + str(index)


func set_label(text):
	sentence_preview.text = text
