extends TileMapLayer

var treasure_scene = preload("res://scenes/treasure.tscn")

func _ready():
	var lua = LuaState.new()
	lua.open_libraries()
	var map = lua.do_string("""local astray = require('astray/astray')
	
	local height, width = %s, %s
	local generator = astray.Astray:new(
		math.floor(width / 2) - 1,
		math.floor(height / 2) - 1,
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
	
	for y in range(-3, map.length() * 2 + 4):
		for x in range(-5, map.get(0).length() * 2 + 7):
			wall_cells.append(Vector2i(x, y))
	
	for y in range(0, map.length() + 1):
		for x in range(0, map.get(0).length() + 1):
			var ch = map.get(y).get(x)
			if ch == "#":
				pass
			else: # door or floor
				if ch == "A":
					$"../Player".position = Vector2(x * 256 + 128, y * 256 + 128)
				if ch == "B":
					elevator_pos = Vector2(x, y)
				if ch == "$":
					var treasure = treasure_scene.instantiate()
					treasure.position = Vector2(x * 256, y * 256)
					get_parent().add_child.call_deferred(treasure)
				path_cells.append(Vector2i(x * 2, y * 2))
				path_cells.append(Vector2i(x * 2 + 1, y * 2))
				path_cells.append(Vector2i(x * 2, y * 2 + 1))
				path_cells.append(Vector2i(x * 2 + 1, y * 2 + 1))
			map_str += ch
		map_str += "\n"
	print(map_str)
	
	set_cells_terrain_connect(wall_cells, Vars.spooky_level, 0)
	set_cells_terrain_connect(path_cells, Vars.spooky_level, 1)
	
	var offset = Vector2.ZERO
	if map.get(elevator_pos.y - 1).get(elevator_pos.x) == "#":
		offset.y += 0
	if map.get(elevator_pos.y + 1).get(elevator_pos.x) == "#":
		offset.y -= 1
	if map.get(elevator_pos.y).get(elevator_pos.x - 1) == "#":
		offset.x += 0
	if map.get(elevator_pos.y).get(elevator_pos.x + 1) == "#":
		offset.x -= 1
	
	for x in range(elevator_pos.x + offset.x, elevator_pos.x + offset.x + 2):
		for y in range(elevator_pos.y + offset.y, elevator_pos.y + offset.y + 2):
			set_cell(Vector2i(x * 2, y * 2), 0, Vector2i(12, 4))
			set_cell(Vector2i(x * 2 + 1, y * 2), 0, Vector2i(12, 4))
			set_cell(Vector2i(x * 2, y * 2 + 1), 0, Vector2i(12, 4))
			set_cell(Vector2i(x * 2 + 1, y * 2 + 1), 0, Vector2i(12, 4))
	
	var area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var rectangle_shape = RectangleShape2D.new()
	
	rectangle_shape.size = Vector2(512, 512)
	
	collision_shape.position = (offset + Vector2(1 + elevator_pos.x, 1 + elevator_pos.y)) * 256
	collision_shape.shape = rectangle_shape
	
	area.collision_layer = 0
	area.collision_mask = 2
	
	area.add_child(collision_shape)
	area.set_script(load("res://scripts/proceed.gd"))
	
	$"..".add_child.call_deferred(area)
	
