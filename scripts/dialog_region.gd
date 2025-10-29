extends Area2D

@export var dialog: String

func send_dialog(_body: Node2D):
	SignalMan.send_dialog.emit(dialog)

func close_dialog(_body: Node2D):
	SignalMan.close_dialog.emit()

func _ready():
	body_entered.connect(send_dialog)
	body_exited.connect(close_dialog)
