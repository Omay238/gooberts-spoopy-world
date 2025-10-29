extends Control

@export var dialog_line: Array[String] = [];

var speaking = false

var mouth = false

func render_dialog(dialog: String):
	speaking = true
	
	var regex = RegEx.new()
	regex.compile(r"\{[^}]*\}|[^{}]+")

	var results = []
	for result in regex.search_all(dialog):
		results.append(result.get_string())
	
	var interval = 0.1
	
	for item in results:
		if !speaking:
			SignalMan.close_mouth.emit()
			break
		
		if item[0] == "{" and item[-1] == "}":
			if item.contains("interval"):
				interval = float(item.split(":")[-1].split("}")[0])
			if item.contains("wink"):
				SignalMan.close_left_eye.emit()
				await get_tree().create_timer(float(item.split(":")[-1].split("}")[0])).timeout
				SignalMan.open_left_eye.emit()
		else:
			for ch in item:
				if !speaking:
					SignalMan.close_mouth.emit()
					break
				
				(SignalMan.close_mouth if mouth else SignalMan.open_mouth).emit()
				
				mouth = !mouth
				$Label.text += ch
				await get_tree().create_timer(interval).timeout
	
	SignalMan.close_mouth.emit()


func send_dialog(dialog: String):
	show()
	render_dialog(dialog)

func close_dialog():
	speaking = false
	$Label.text = ""
	hide()

func _ready():
	SignalMan.send_dialog.connect(send_dialog)
	SignalMan.close_dialog.connect(close_dialog)
