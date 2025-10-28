extends RigidBody2D

func _process(_delta: float) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	apply_central_force(input * 40000);
