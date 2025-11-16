extends TileMapLayer

func _ready():
	var lua = LuaState.new()
	lua.open_libraries()
	var map = lua.do_string("""local astray = require('astray/astray')
	
	local height, width = %s, %s
	local generator = astray.Astray:new(
		width / 2 - 1,
		height / 2 - 1,
		30,
		70,
		50,
		astray.RoomGenerator:new(
			4,
			2, 4,
			2, 4,
			40
		)
	)
	
	local dungeon = generator:Generate()
	
	return generator:CellToTiles(dungeon)""" % [32 + Vars.id, 32 + Vars.id])
	
	var map_str = ""
	
	var path_cells = []
	var wall_cells = []
	var elevator_pos = Vector2.ZERO
	
	for y in range(0, map.get(0).length() + 1):
		for x in range(0, map.length() + 1):
			var ch = map.get(x).get(y)
			if ch == "#":
				wall_cells.append(Vector2i(x * 2, y * 2))
				wall_cells.append(Vector2i(x * 2 + 1, y * 2))
				wall_cells.append(Vector2i(x * 2, y * 2 + 1))
				wall_cells.append(Vector2i(x * 2 + 1, y * 2 + 1))
			else: # door or floor
				if ch == "A":
					$"../Player".position = Vector2(x * 256, y * 256)
				elif ch == "B":
					elevator_pos = Vector2(x * 2, y * 2)
				path_cells.append(Vector2i(x * 2, y * 2))
				path_cells.append(Vector2i(x * 2 + 1, y * 2))
				path_cells.append(Vector2i(x * 2, y * 2 + 1))
				path_cells.append(Vector2i(x * 2 + 1, y * 2 + 1))
			map_str += ch
		map_str += "\n"
	print(map_str)
	
	set_cells_terrain_connect(wall_cells, Vars.spooky_level, 0)
	set_cells_terrain_connect(path_cells, Vars.spooky_level, 1)
	
	for x in range(elevator_pos.x, elevator_pos.x + 2):
		for y in range(elevator_pos.y, elevator_pos.y + 2):
			set_cell(Vector2i(x, y), 0, Vector2i(12, 4))
