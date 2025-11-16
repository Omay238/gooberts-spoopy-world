extends Control

var is_player_in = false
var available = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("collect") and is_player_in and available:
		Vars.moneys += 10
		$TileMapLayer.set_cell(Vector2i(0, 0), 0, Vector2i(17, 1))
		available = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	is_player_in = true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	is_player_in = false
