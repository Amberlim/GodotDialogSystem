extends Button

var node_index

signal option_pressed


func _on_Option_pressed():
	emit_signal("option_pressed", node_index)
