extends TileMapLayer

var fin_script = preload("res://scripts/proceed.gd")

func bfs_furthest(grid, sx, sy) -> Vector2i:
	var height = grid.size()
	var width = grid[0].size()
	
	var visited = []
	for y in range(height):
		visited.append([])
		for x in range(width):
			visited[y].append(false)
	
	var queue = [[sx, sy, 0]]
	visited[sy][sx] = true
	
	var furthest_point = Vector2i(sx, sy)
	var furthest_distance = 0
	
	while not queue.is_empty():
		var queue_elem = queue.pop_front()
		var x = queue_elem[0]
		var y = queue_elem[1]
		var dst = queue_elem[2]
		
		if dst > furthest_distance:
			furthest_distance = dst
			furthest_point = Vector2i(x, y)
		
		var current_cell = grid[y][x]
		
		if not (current_cell & 0b10000):
			if y > 0 and not visited[y - 1][x]:
				visited[y - 1][x] = true
				queue.append([x, y - 1, dst + 1])
		if not (current_cell & 0b01000):
			if x < width - 1 and not visited[y][x + 1]:
				visited[y][x + 1] = true
				queue.append([x + 1, y, dst + 1])
		if not (current_cell & 0b00100):
			if y < height - 1 and not visited[y + 1][x]:
				visited[y + 1][x] = true
				queue.append([x, y + 1, dst + 1])
		if not (current_cell & 0b00010):
			if x > 0 and not visited[y][x - 1]:
				visited[y][x - 1] = true
				queue.append([x - 1, y, dst + 1])
	
	return furthest_point

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
	
	var cx = randi() % width
	var cy = randi() % height
	
	grid[cy][cx] = 0b11111
	
	var visited = 1
	
	var total = width * height
	
	while visited < total:
		var neighbors = []
		
		# i've like, never used bitwise operations
		if cy > 0: neighbors.append([cx, cy - 1, 0b00])
		if cy + 1 < height: neighbors.append([cx, cy + 1, 0b01])
		if cx > 0: neighbors.append([cx - 1, cy, 0b10])
		if cx + 1 < width: neighbors.append([cx + 1, cy, 0b11])
		
		var neighbor = neighbors.pick_random()
		
		var nx = neighbor[0]
		var ny = neighbor[1]
		
		if not (grid[ny][nx] & 0b00001):
			# they call me john bitwise
			if neighbor[2] == 0b00:
				grid[cy][cx] &= 0b01111
				grid[ny][nx] &= 0b11011
			elif neighbor[2] == 0b01:
				grid[cy][cx] &= 0b11011
				grid[ny][nx] &= 0b01111
			elif neighbor[2] == 0b10:
				grid[cy][cx] &= 0b11101
				grid[ny][nx] &= 0b10111
			elif neighbor[2] == 0b11:
				grid[cy][cx] &= 0b10111
				grid[ny][nx] &= 0b11101
			
			grid[ny][nx] |= 0b00001
			visited += 1
		
		cx = nx
		cy = ny
	
	var b = bfs_furthest(grid, width - 1, height - 1)
	var c = bfs_furthest(grid, b.x, b.y)
	
	var tiles = []
	var floor_tiles = []
	
	var room_width := 10
	var room_height := 8
	var hall_length := 5
	var hall_width := 2
	var margin_x := 7
	var margin_y := 5
	
	var total_width := (room_width + hall_length) * width + margin_x + 1
	var total_height := (room_height + hall_length) * height + margin_y + 1
	
	# generate a blank canvas of wall
	for y in range(total_height):
		for x in range(total_width):
			tiles.append(Vector2i(x - margin_x, y - margin_y))
	
	set_cells_terrain_connect(tiles, Vars.spooky_level, 0)
	
	var map_str = ""
	
	for y in range(height):
		for x in range(width):
			var scaled_x := x * (room_width + hall_length)
			var scaled_y := y * (room_height + hall_length)
			
			@warning_ignore("integer_division")
			var x_half_less = scaled_x + ((room_width - hall_width) / 2)
			@warning_ignore("integer_division")
			var y_half_less = scaled_y + ((room_height - hall_width) / 2)
			
			if x == c.x and y == c.y:
				var offset = Vector2i(0, 0)
				
				if not (grid[y][x] & 0b10000):
					@warning_ignore("integer_division")
					offset = Vector2i(room_width / 2 - 1, 1)
				elif not (grid[y][x] & 0b01000):
					@warning_ignore("integer_division")
					offset = Vector2i(room_width - 3, room_height / 2 - 1)
				elif not (grid[y][x] & 0b00100):
					@warning_ignore("integer_division")
					offset = Vector2i(room_width / 2 - 1, room_height - 3)
				elif not (grid[y][x] & 0b00010):
					@warning_ignore("integer_division")
					offset = Vector2i(1, room_height / 2 - 1)
				
				for ey in range(4):
					for ex in range(4):
						set_cell(Vector2i(scaled_x + ex - 1, scaled_y + ey - 1) + offset, 0, Vector2i(12, 4))
				
				
				var area = Area2D.new()
				var collision_shape = CollisionShape2D.new()
				var rectangle_shape = RectangleShape2D.new()
				
				rectangle_shape.size = Vector2i(512, 512)
				
				collision_shape.position = (offset + Vector2i(1 + scaled_x, 1 + scaled_y)) * 128
				collision_shape.shape = rectangle_shape
				
				area.collision_layer = 0
				area.collision_mask = 2
				
				area.add_child(collision_shape)
				area.set_script(load("res://scripts/proceed.gd"))
				
				$"..".add_child.call_deferred(area)
			else:
				# 0b<up><right><down><left><visited>
				
				# room
				for ry in range(room_height):
					for rx in range(room_width):
						floor_tiles.append(Vector2i(scaled_x + rx, scaled_y + ry))
				
				# halls
				if not (grid[y][x] & 0b10000):
					for hy in range(-hall_length, 0):
						for hx in range(hall_width):
							floor_tiles.append(Vector2i(x_half_less + hx, scaled_y + hy))
				
				if not (grid[y][x] & 0b01000):
					for hy in range(hall_width):
						for hx in range(hall_length):
							floor_tiles.append(Vector2i(scaled_x + room_width + hx, y_half_less + hy))
				
				if not (grid[y][x] & 0b00100):
					for hy in range(hall_length):
						for hx in range(hall_width):
							floor_tiles.append(Vector2i(x_half_less + hx, scaled_y + room_height + hy))
				
				if not (grid[y][x] & 0b00010):
					for hy in range(hall_width):
						for hx in range(-hall_length, 0):
							floor_tiles.append(Vector2i(scaled_x + hx, y_half_less + hy))
			
			if x == b.x and y == b.y:
				map_str += "A"
				continue
			if x == c.x and y == c.y:
				map_str += "B"
				continue
			
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
	
	@warning_ignore("integer_division", "narrowing_conversion")
	$"../Player".position = ((b * Vector2i(room_width + hall_length, room_height + hall_length) + Vector2i(room_width * 0.5, room_height * 0.5))) * 128
	
	print(map_str)
