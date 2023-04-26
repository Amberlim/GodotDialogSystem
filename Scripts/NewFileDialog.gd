extends FileDialog


enum enum_mode {NEW, OPEN}
var open_mode: enum_mode

func _on_control_resized():
	var new_pos: Vector2 = get_parent().get_window().get_size_with_decorations() / 2 - size / 2
	position = new_pos


func _on_new_file_btn_pressed():
	show()
	open_mode = enum_mode.NEW


func _on_open_file_btn_pressed():
	show()
	open_mode = enum_mode.OPEN
