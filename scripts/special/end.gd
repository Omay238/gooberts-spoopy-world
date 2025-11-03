extends Control

func _process(delta: float):
	if $Label.position.y > -870:
		$Label.position.y -= 60 * delta
