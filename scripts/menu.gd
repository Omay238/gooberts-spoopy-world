extends Node

var left_eye = false;
var mouth = true;
var right_eye = false;

func timer_1():
	(SignalMan.close_left_eye if left_eye else SignalMan.open_left_eye).emit()
	left_eye = !left_eye

func timer_2():
	(SignalMan.close_mouth if mouth else SignalMan.open_mouth).emit()
	mouth = !mouth

func timer_3():
	(SignalMan.close_right_eye if right_eye else SignalMan.open_right_eye).emit()
	right_eye = !right_eye


func play():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func quit():
	get_tree().quit()
