extends Area2D

func change_scene(_body):
	Vars.id += 1
	print("sent signal")
	SignalMan.change_scene.emit()

func _ready() -> void:
	body_entered.connect(change_scene)
