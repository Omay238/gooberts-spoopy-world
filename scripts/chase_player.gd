extends RigidBody2D

var cutscene = false

var speed = 40000
var started = true
var cs2 = false

func change_scene(scene: int):
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect2, "size", Vector2(2882, 1622), 1.0).finished
	
	if scene == 0:
		get_tree().change_scene_to_file("res://scenes/special_floors/end.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/special_floors/death.tscn")

func _ready() -> void:
	if Vars.spooky_level == 2:
		$Camera2D/CRT.show()
	
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect, "position", Vector2(769, -432), 1.0).finished
	$Camera2D/ColorRect.size = Vector2(0, 864)
	$Camera2D/ColorRect.position = Vector2(-769, -432)

func _process(delta: float) -> void:
	$"../Face".position.y = position.y
	
	if cutscene and not cs2:
		exec_cutscene()
	elif started:
		var input = Input.get_vector("move_left", "move_right", "move_up", "move_down");
		
		apply_central_force(input * speed);
		$"../Face".position.x += 19 * 60 * delta
	elif not cs2:
		apply_central_force(position.direction_to(Vector2i(128, 1280)) * speed * position.distance_to(Vector2i(128, 1280)) * 0.01);


func exec_cutscene():
	cutscene = false
	started = false
	
	$"../Face".position.x = -768
	
	var scale_tween = get_tree().create_tween()
	var position_tween = get_tree().create_tween()
	var zoom_tween = get_tree().create_tween()
	scale_tween.tween_property($Camera2D/CRT, "scale", Vector2(1.875, 1.875), 2.0)
	position_tween.tween_property($Camera2D/CRT, "position", Vector2(-1440, -810), 2.0)
	await zoom_tween.tween_property($Camera2D, "zoom", Vector2(0.4, 0.4), 2.0).finished
	
	$"../Face".show()
	
	SignalMan.open_mouth.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.close_mouth.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.open_mouth.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.close_mouth.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.open_mouth.emit()
	await get_tree().create_timer(0.5).timeout
	SignalMan.close_mouth.emit()
	
	SignalMan.send_dialog.emit("i told you i'd fix you.")
	await get_tree().create_timer(4).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("now run...")
	await get_tree().create_timer(2).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("or die!")
	await get_tree().create_timer(2).timeout
	SignalMan.close_dialog.emit()
	
	if $"../Area2D" != null:
		$"../Area2D".queue_free()
	
	speed = 80000
	
	started = true
	
	$"../Face/Area2D".monitoring = true
	
	cs2 = true

func exec_cutscene_2():
	$"../Face/Area2D".monitoring = false
	
	var scale_tween = get_tree().create_tween()
	await scale_tween.tween_property($"../Face", "scale", Vector2(2, 2), 1.0).finished
	
	started = false
	cutscene = true
	
	SignalMan.open_mouth.emit()
	await get_tree().create_timer(2).timeout
	SignalMan.close_mouth.emit()
	
	SignalMan.send_dialog.emit("{interval:0.2}well... huh")
	await get_tree().create_timer(4).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("guess that's it.")
	await get_tree().create_timer(2.5).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("i've got nothing left for you.")
	await get_tree().create_timer(4).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("{interval:0.25}are you happy?")
	await get_tree().create_timer(4).timeout
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("bye.")
	SignalMan.close_left_eye.emit()
	SignalMan.close_right_eye.emit()
	await get_tree().create_timer(2).timeout
	SignalMan.close_dialog.emit()
	
	change_scene(0)
	


func _on_enter_arena(body: Node2D) -> void:
	if body == self:
		cutscene = true


func _on_goobert_collide(body: Node2D) -> void:
	if body == self:
		change_scene(1)


func _finish(body: Node2D) -> void:
	if body == self:
		exec_cutscene_2()
