extends RigidBody2D

# 0 1538

func change_scene():
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect, "size", Vector2(1538, 864), 1.0).finished
	
	get_tree().change_scene_to_file("res://scenes/dyn.tscn")

func _ready() -> void:
	SignalMan.change_scene.connect(change_scene)
	
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect, "position", Vector2(769, -432), 1.0).finished
	$Camera2D/ColorRect.size = Vector2(0, 864)
	$Camera2D/ColorRect.position = Vector2(-769, -432)

func _process(_delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	apply_central_force(input * 40000);
