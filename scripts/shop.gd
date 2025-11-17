extends Area2D

func _ready() -> void:
	if Vars.map or 50 > Vars.moneys:
		$"../../ShopMenu/Map".disabled = true
		if Vars.map:
			$"../../ShopMenu/Map".text = "sold out D:"
	
	if Vars.speed * 10 > Vars.moneys:
		$"../../ShopMenu/Speed".disabled = true
	$"../../ShopMenu/Speed".text = "more speedy - %s moneys" % (Vars.speed * 10)
	
	SignalMan.send_dialog.emit("how's it hanging my giggidy gamer?")
	await get_tree().create_timer(4.5).timeout
	SignalMan.close_dialog.emit()


func _on_body_entered(_body: Node2D) -> void:
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("ay check it")
	$"../../ShopMenu".show()
	var tween = get_tree().create_tween()
	tween.tween_property($"../Player/Camera2D", "position", Vector2(0, -400), 1.0)
	await get_tree().create_timer(2).timeout
	SignalMan.close_dialog.emit()


func _on_body_exited(_body: Node2D) -> void:
	SignalMan.close_dialog.emit()
	SignalMan.send_dialog.emit("cya my mans")
	$"../../ShopMenu".hide()
	var tween = get_tree().create_tween()
	tween.tween_property($"../Player/Camera2D", "position", Vector2(0, 0), 1.0)
	await get_tree().create_timer(2).timeout
	SignalMan.close_dialog.emit()


func _on_speed_button_down() -> void:
	Vars.moneys -= Vars.speed * 10
	Vars.speed += 1
	if Vars.speed * 10 > Vars.moneys:
		$"../../ShopMenu/Speed".disabled = true
	$"../../ShopMenu/Speed".text = "more speedy - %s moneys" % (Vars.speed * 10)


func _on_map_button_down() -> void:
	Vars.moneys -= 50
	Vars.map = true
	$"../../ShopMenu/Map".disabled = true
