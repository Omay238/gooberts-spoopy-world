extends Control

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	SignalMan.send_dialog.emit("oh, you've died")
	await get_tree().create_timer(2.5).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("welcome to my void!")
	await get_tree().create_timer(3).timeout
	SignalMan.close_right_eye.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.open_right_eye.emit()
	await get_tree().create_timer(1).timeout
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
	Vars.moneys = 0
	Vars.speed = 1
	Vars.map = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

var delta_cum = 0
func _process(delta: float) -> void:
	delta_cum += delta
	$FaceRoot/Face.rotation = delta_cum
	$FaceRoot/Face.position = Vector2(sin(delta_cum), cos(delta_cum)) * 10
	$PlayerRoot/Player.position = Vector2(sin(delta_cum), cos(delta_cum)) * 10
