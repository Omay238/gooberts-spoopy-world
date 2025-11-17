extends Node

func _init():
	SignalMan.new_map.connect(update_map)

func update_map(map: String):
	for y in range(map.split("\n").size() - 1):
		for x in range(map.split("\n")[0].length()):
			if map.split("\n")[y][x] == "#":
				$TileMapLayer.set_cell(Vector2i(x, y), 0, Vector2i(1, 0))
			elif map.split("\n")[y][x] == "B":
				$TileMapLayer.set_cell(Vector2i(x, y), 0, Vector2i(1, 1))
			elif map.split("\n")[y][x] == "$":
				$TileMapLayer.set_cell(Vector2i(x, y), 0, Vector2i(0, 1))
			else:
				$TileMapLayer.set_cell(Vector2i(x, y), 0, Vector2i(0, 0))
