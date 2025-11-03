extends Node

@onready var mouth_open: TextureRect = $MouthOpen;
@onready var mouth_closed: TextureRect = $MouthClosed;
@onready var left_eye_open: TextureRect = $LeftEyeOpen;
@onready var right_eye_open: TextureRect = $RightEyeOpen;
@onready var left_eye_closed: TextureRect = $LeftEyeClosed;
@onready var right_eye_closed: TextureRect = $RightEyeClosed;

var mouth_open_textures = [
	preload("res://images/face/evil/mouth_open1.png"),
	preload("res://images/face/evil/mouth_open2.png"),
	preload("res://images/face/evil/mouth_open3.png"),
	preload("res://images/face/evil/mouth_open4.png"),
]

var mouth_closed_textures = [
	preload("res://images/face/evil/mouth_closed1.png"),
	preload("res://images/face/evil/mouth_closed2.png"),
	preload("res://images/face/evil/mouth_closed3.png"),
	preload("res://images/face/evil/mouth_closed4.png"),
]

var left_eye_open_textures = [
	preload("res://images/face/evil/left_eye_open1.png"),
	preload("res://images/face/evil/left_eye_open2.png"),
	preload("res://images/face/evil/left_eye_open3.png"),
	preload("res://images/face/evil/left_eye_open4.png"),
]

var right_eye_open_textures = [
	preload("res://images/face/evil/right_eye_open1.png"),
	preload("res://images/face/evil/right_eye_open2.png"),
	preload("res://images/face/evil/right_eye_open3.png"),
	preload("res://images/face/evil/right_eye_open4.png"),
]

var left_eye_closed_textures = [
	preload("res://images/face/evil/left_eye_closed1.png"),
	preload("res://images/face/evil/left_eye_closed2.png"),
	preload("res://images/face/evil/left_eye_closed3.png"),
	preload("res://images/face/evil/left_eye_closed4.png"),
]

var right_eye_closed_textures = [
	preload("res://images/face/evil/right_eye_closed1.png"),
	preload("res://images/face/evil/right_eye_closed2.png"),
	preload("res://images/face/evil/right_eye_closed3.png"),
	preload("res://images/face/evil/right_eye_closed4.png"),
]

var tex_id = 0

func update_textures():
	mouth_open.texture = mouth_open_textures[tex_id]
	mouth_closed.texture = mouth_closed_textures[tex_id]
	left_eye_open.texture = left_eye_open_textures[tex_id]
	right_eye_open.texture = right_eye_open_textures[tex_id]
	left_eye_closed.texture = left_eye_closed_textures[tex_id]
	right_eye_closed.texture = right_eye_closed_textures[tex_id]
	
	tex_id = (tex_id + 1) % 4


func _ready():
	SignalMan.open_mouth.connect(open_mouth)
	SignalMan.close_mouth.connect(close_mouth)
	SignalMan.open_left_eye.connect(open_left_eye)
	SignalMan.open_right_eye.connect(open_right_eye)
	SignalMan.close_left_eye.connect(close_left_eye)
	SignalMan.close_right_eye.connect(close_right_eye)
	
	$Timer.timeout.connect(update_textures)


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
