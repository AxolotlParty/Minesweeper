extends Node

class_name GameBoard
var _columns: int
var _rows: int
var _mine_count: int
var flag_count: int
var _board_state = []
var visible_board_state = []
const NEIGHBOR_OFFSETS = [Vector2i(-1, -1), Vector2i(-1, 0), Vector2i(-1, 1),
						  Vector2i(0, -1), Vector2i(0, 1),
						  Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1)]


func initialise(configuration: GameStateConfiguration) -> void:
	_columns = configuration.columns
	_rows = configuration.rows
	_mine_count = configuration.mine_count
	flag_count = configuration.mine_count
	
	_board_state.resize(_columns * _rows)
	visible_board_state.resize(_columns * _rows)
	visible_board_state.fill(Enums.CellType.UNKNOWN)
	_board_state.fill(Enums.CellType.EMPTY)

func is_won() -> bool:
	var counter = 0
	for index in range(visible_board_state.size()):
		if visible_board_state[index] != _board_state[index]:
			counter += 1
	
	return counter == _mine_count
	
func reveal() -> void:
	for index in range(visible_board_state.size()):
		
		if visible_board_state[index] == Enums.CellType.UNKNOWN:
			visible_board_state[index] = _board_state[index]
			
		if visible_board_state[index] == Enums.CellType.FLAGGED:
			if _board_state[index] == Enums.CellType.MINE:
				visible_board_state[index] = _board_state[index]
			else:
				visible_board_state[index] = Enums.CellType.FALSE_FLAGGED
	
func on_clear(cell_index: int, is_first_click: bool) -> bool:
	if cell_index < 0 or cell_index >= visible_board_state.size():
		return true
		
	if is_first_click:
		_populate_board(cell_index)
	
	return _clear_cell(cell_index)

func on_block_clear(cell_index: int) -> bool:
	if cell_index < 0 or cell_index >= visible_board_state.size():
		return true
		
	match visible_board_state[cell_index]:
			8,9,10,11,12,13,14,15:
				print("Start Clear")
				var neighbors = _get_neighbors(cell_index)
				var neighbor_values = neighbors.map(func(i): return visible_board_state[i])
				var flags = neighbor_values.filter(func(x): return x == Enums.CellType.FLAGGED).size()
				
				if flags == visible_board_state[cell_index] - 7:
					for neighbor in neighbors:
						if visible_board_state[neighbor] == Enums.CellType.UNKNOWN:
							var is_safe = _clear_cell(neighbor)
							if is_safe == false:
								return false;
	return true
	
func _populate_board(cell_index) -> void:
	var indices = range(_board_state.size())
	indices.erase(cell_index)
	indices.shuffle()
	
	for i in range(_mine_count):
		_board_state[indices[i]] = Enums.CellType.MINE

	_calculate_adjacent_mines()

func _calculate_adjacent_mines() -> void:
	for index in range(_board_state.size()):
		if _board_state[index] == Enums.CellType.MINE:
			continue
		var neighbors := _get_neighbors(index)
		
		var sum = 0
		for neighbor in neighbors:
			if _board_state[neighbor] == Enums.CellType.MINE:
				sum += 1
		
		match sum:
			0:
				_board_state[index] = Enums.CellType.EMPTY
			1,2,3,4,5,6,7,8:
				_board_state[index] = sum + 7
				
func on_flag(cell_index: int) -> void:
	if (cell_index < 0 || cell_index > visible_board_state.size()):
		return
	
	match visible_board_state[cell_index]:
		0:
			if flag_count > 0:
				visible_board_state[cell_index] = Enums.CellType.FLAGGED
				flag_count -= 1
		2:
			visible_board_state[cell_index] = Enums.CellType.QUESTION_MARK
			flag_count += 1
		3:
			visible_board_state[cell_index] = Enums.CellType.UNKNOWN

func _clear_cell(cell_index: int) -> bool:
	var is_safe: bool = true
	
	visible_board_state[cell_index] = _board_state[cell_index]

	match _board_state[cell_index]:
		Enums.CellType.EMPTY:
			_flood_reveal(cell_index)
		Enums.CellType.MINE:
			is_safe = false
			visible_board_state[cell_index] = Enums.CellType.EXPLOSION
	
	return is_safe

func _get_neighbors(index: int) -> Array:
	var position = Vector2i(index % _columns, index / _rows)
	var neighbors = []

	for offset in NEIGHBOR_OFFSETS:
		var new_position = position + offset
		if new_position.x >= 0 and new_position.x < _columns and new_position.y >= 0 and new_position.y < _rows:
			neighbors.append(new_position.y * _columns + new_position.x)

	return neighbors

func _flood_reveal(start_index: int):
	var queue = [start_index]
	
	while queue.size() > 0:
		var cell_index = queue.pop_front()
		visible_board_state[cell_index] = _board_state[cell_index]

		if _board_state[cell_index] == Enums.CellType.EMPTY:
			for neighbor in _get_neighbors(cell_index):
				if visible_board_state[neighbor] == 0:
					queue.append(neighbor)
