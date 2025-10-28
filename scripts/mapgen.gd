extends TileMapLayer

func _ready():
	var grid = []
	
	var width = 8;
	var height = 8;
	
	
	# 0b<up><right><down><left><visited>
	for y in range(height):
		grid.append([]);
		for x in range(width):
			grid[y].append(0b11110);
	
	grid[0][0] = 0b11111
	
	var stack = [[0, 0]]
	
	
	while len(stack) > 0:
		var x = stack[-1][0]
		var y = stack[-1][1]
		var neighbors = []
		
		# i've like, never used bitwise operations
		if y > 0 && !grid[y - 1][x] & 0b00001: neighbors.append([x, y - 1, 0b00])
		if y + 1 < height && !grid[y + 1][x] & 0b00001: neighbors.append([x, y + 1, 0b01])
		if x > 0 && !grid[y][x - 1] & 0b00001: neighbors.append([x - 1, y, 0b10])
		if x + 1 < width && !grid[y][x + 1] & 0b00001: neighbors.append([x + 1, y, 0b11])
		
		if len(neighbors) > 0:
			var neighbor = neighbors.pick_random()
			
			var nx = neighbor[0]
			var ny = neighbor[1]
			
			# they call me john bitwise
			if neighbor[2] == 0b00:
				grid[y][x] &= 0b01111
				grid[ny][nx] &= 0b11011
			elif neighbor[2] == 0b01:
				grid[y][x] &= 0b11011
				grid[ny][nx] &= 0b01111
			elif neighbor[2] == 0b10:
				grid[y][x] &= 0b11101
				grid[ny][nx] &= 0b10111
			elif neighbor[2] == 0b11:
				grid[y][x] &= 0b10111
				grid[ny][nx] &= 0b11101
			
			grid[ny][nx] |= 0b00001
			stack.append([nx, ny])
		else:
			stack.pop_back()
	
	var map_str = ""
	
	var tiles = []
	
	for y in range(height):
		for x in range(width):
			# 0b<up><right><down><left><visited>
			tiles.append(Vector2i(x * 3 + 1, y * 3 + 1))
			tiles.append(Vector2i(x * 3 + 1, y * 3 - 1))
			tiles.append(Vector2i(x * 3 - 1, y * 3 + 1))
			tiles.append(Vector2i(x * 3 - 1, y * 3 - 1))
			
			if grid[y][x] & 0b10000:
				tiles.append(Vector2i(x * 3, y * 3 - 1))
			elif grid[y][x] & 0b01000:
				tiles.append(Vector2i(x * 3 + 1, y * 3))
			elif grid[y][x] & 0b00100:
				tiles.append(Vector2i(x * 3, y * 3 + 1))
			elif grid[y][x] & 0b00010:
				tiles.append(Vector2i(x * 3 - 1, y * 3))
			
			if grid[y][x] == 0b00001:
				map_str += "┼"
			elif grid[y][x] == 0b00011:
				map_str += "├"
			elif grid[y][x] == 0b00101:
				map_str += "┴"
			elif grid[y][x] == 0b00111:
				map_str += "└"
			elif grid[y][x] == 0b01001:
				map_str += "┤"
			elif grid[y][x] == 0b01011:
				map_str += "│"
			elif grid[y][x] == 0b01101:
				map_str += "┘"
			elif grid[y][x] == 0b01111:
				map_str += "╵"
			elif grid[y][x] == 0b10001:
				map_str += "┬"
			elif grid[y][x] == 0b10011:
				map_str += "┌"
			elif grid[y][x] == 0b10101:
				map_str += "─"
			elif grid[y][x] == 0b10111:
				map_str += "╶"
			elif grid[y][x] == 0b11001:
				map_str += "┐"
			elif grid[y][x] == 0b11011:
				map_str += "╷"
			elif grid[y][x] == 0b11101:
				map_str += "╴"
			elif grid[y][x] == 0b11111:
				map_str += "╳"
		map_str += "\n"
	
	set_cells_terrain_connect(tiles, 0, 0)
	
	print(map_str)
	
