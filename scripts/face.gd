extends Node

@onready var mouth_open: TextureRect = $MouthOpen;
@onready var mouth_closed: TextureRect = $MouthClosed;
@onready var left_eye_open: TextureRect = $LeftEyeOpen;
@onready var right_eye_open: TextureRect = $RightEyeOpen;
@onready var left_eye_closed: TextureRect = $LeftEyeClosed;
@onready var right_eye_closed: TextureRect = $RightEyeClosed;


func _ready():
	SignalMan.open_mouth.connect(open_mouth)
	SignalMan.close_mouth.connect(close_mouth)
	SignalMan.open_left_eye.connect(open_left_eye)
	SignalMan.open_right_eye.connect(open_right_eye)
	SignalMan.close_left_eye.connect(close_left_eye)
	SignalMan.close_right_eye.connect(close_right_eye)


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
