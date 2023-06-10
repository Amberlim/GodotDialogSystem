extends Window


func _ready():
	$PanelContainer/VersionLabel.text = "v" + ProjectSettings.get("application/config/version")
	

func _on_control_resized():
	var new_pos: Vector2 = get_parent().get_window().get_size_with_decorations() / 2 - size / 2
	position = new_pos
