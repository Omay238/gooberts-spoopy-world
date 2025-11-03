extends Control

func _process(delta: float):
	$Label.position.y -= 60 * delta
