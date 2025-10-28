extends Node

@onready var mouth_open = $MouthOpen;
@onready var mouth_closed = $MouthClosed;
@onready var left_eye_open = $LeftEyeOpen;
@onready var right_eye_open = $RightEyeOpen;
@onready var left_eye_closed = $LeftEyeClosed;
@onready var right_eye_closed = $RightEyeClosed;


func _ready():
	SignalMan.connect("open_mouth", open_mouth)
	SignalMan.connect("close_mouth", close_mouth)
	SignalMan.connect("open_left_eye", open_left_eye)
	SignalMan.connect("open_right_eye", open_right_eye)
	SignalMan.connect("close_left_eye", close_left_eye)
	SignalMan.connect("close_right_eye", close_right_eye)


func open_mouth():
	mouth_closed.hide()
	mouth_open.show()
func close_mouth():
	mouth_open.hide()
	mouth_closed.show()
func open_left_eye():
	left_eye_closed.hide()
	left_eye_open.show()
func open_right_eye():
	right_eye_closed.hide()
	right_eye_open.show()
func close_left_eye():
	left_eye_open.hide()
	left_eye_closed.show()
func close_right_eye():
	right_eye_open.hide()
	right_eye_closed.show()
