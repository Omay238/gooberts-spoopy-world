extends TileMapLayer

func _ready():
	var grid = []
	
	@warning_ignore("integer_division")
	var width := 2 + Vars.id / 4;
	@warning_ignore("integer_division")
	var height := 2 + Vars.id / 4;
	
	
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
		if y > 0 && !(grid[y - 1][x] & 0b00001): neighbors.append([x, y - 1, 0b00])
		if y + 1 < height && !(grid[y + 1][x] & 0b00001): neighbors.append([x, y + 1, 0b01])
		if x > 0 && !(grid[y][x - 1] & 0b00001): neighbors.append([x - 1, y, 0b10])
		if x + 1 < width && !(grid[y][x + 1] & 0b00001): neighbors.append([x + 1, y, 0b11])
		
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
	
	var tiles = []
	var floor_tiles = []
	
	var room_width := 10
	var room_height := 8
	var hall_length := 5
	var hall_width := 2
	var margin_x := 7
	var margin_y := 5
	
	var total_width := (room_width + hall_length) * width + margin_x * 2
	var total_height := (room_height + hall_length) * height + margin_y * 2
	
	# generate a blank canvas of wall
	for y in range(total_height):
		for x in range(total_width):
			tiles.append(Vector2i(x - margin_x, y - margin_y))
	
	set_cells_terrain_connect(tiles, Vars.spooky_level, 0)
	
	var map_str = ""
	
	for y in range(height):
		for x in range(width):
			# 0b<up><right><down><left><visited>
			
			var scaled_x := x * (room_width + hall_length)
			var scaled_y := y * (room_height + hall_length)
			
			# room
			for ry in range(room_height):
				for rx in range(room_width):
					floor_tiles.append(Vector2i(scaled_x + rx, scaled_y + ry))
			
			# halls
			@warning_ignore("integer_division")
			var x_half_less = scaled_x + ((room_width - hall_width) / 2)
			@warning_ignore("integer_division")
			var y_half_less = scaled_y + ((room_height - hall_width) / 2)
			
			if !grid[y][x] & 0b10000:
				for hy in range(-hall_length, 0):
					for hx in range(hall_width):
						floor_tiles.append(Vector2i(x_half_less + hx, scaled_y + hy))
			
			if !grid[y][x] & 0b01000:
				for hy in range(hall_width):
					for hx in range(hall_length):
						floor_tiles.append(Vector2i(scaled_x + room_width + hx, y_half_less + hy))
			
			if !grid[y][x] & 0b00100:
				for hy in range(hall_length):
					for hx in range(hall_width):
						floor_tiles.append(Vector2i(x_half_less + hx, scaled_y + room_height + hy))
			
			if !grid[y][x] & 0b00010:
				for hy in range(hall_width):
					for hx in range(-hall_length, 0):
						floor_tiles.append(Vector2i(scaled_x + hx, y_half_less + hy))
			
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
	
	set_cells_terrain_connect(floor_tiles, 0, 1)
	
	print(map_str)
