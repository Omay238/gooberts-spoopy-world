extends RigidBody2D

var cutscene = false

var speed = 40000
var started = true

func change_scene():
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect, "size", Vector2(1538, 864), 1.0).finished
	
	
	var el = Vars.floors.find_custom(func(x):return x.floor_num==Vars.id)
	
	if el != -1:
		get_tree().change_scene_to_packed(Vars.floors[el].scene)
	else:
		get_tree().change_scene_to_file("res://scenes/dyn.tscn")

func _ready() -> void:
	if Vars.spooky_level == 2:
		$Camera2D/CRT.show()
	
	SignalMan.change_scene.connect(change_scene)
	
	var stretch_tween = get_tree().create_tween()
	
	stretch_tween.set_trans(Tween.TRANS_QUAD)
	await stretch_tween.tween_property($Camera2D/ColorRect, "position", Vector2(769, -432), 1.0).finished
	$Camera2D/ColorRect.size = Vector2(0, 864)
	$Camera2D/ColorRect.position = Vector2(-769, -432)

func _process(_delta: float) -> void:
	if cutscene:
		exec_cutscene()
	elif started:
		var input = Input.get_vector("move_left", "move_right", "move_up", "move_down");
		
		apply_central_force(input * speed);


func exec_cutscene():
	cutscene = false
	started = false
	
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


func _on_enter_arena(body: Node2D) -> void:
	if body == self:
		cutscene = true
