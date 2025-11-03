extends Control

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	SignalMan.send_dialog.emit("oh, you've died")
	await get_tree().create_timer(2.5).timeout
	SignalMan.close_left_eye.emit()
	SignalMan.close_right_eye.emit()
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("what a shame.")
	await get_tree().create_timer(2.5).timeout
	SignalMan.open_left_eye.emit()
	SignalMan.open_right_eye.emit()
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("i guess i'll send you back to the start{wink:0.5}")
	await get_tree().create_timer(6).timeout
	SignalMan.close_dialog.emit()
	Vars.id = 0
	Vars.spooky_level = 0
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
