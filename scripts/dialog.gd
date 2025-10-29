extends Control

@export var dialog_line: Array[String] = [];

func render_dialog(dialog: String):
	var regex = RegEx.new()
	regex.compile(r"\{[^}]*\}|[^{}]+")

	var results = []
	for result in regex.search_all(dialog):
		results.append(result.get_string())
	
	var interval = 0.1
	
	for item in results:
		if item[0] == "{" and item[-1] == "}":
			if item.contains("interval"):
				interval = float(item.split(":")[-1].split("")[0])
		else:
			for ch in item:
				$Label.text += ch
				await get_tree().create_timer(interval).timeout


func send_dialog(dialog: String):
	show()
	render_dialog(dialog)

func close_dialog():
	hide()

func _ready():
	SignalMan.send_dialog.connect(send_dialog)
	SignalMan.close_dialog.connect(close_dialog)
