extends Node

class_name GameState

signal score_updated
signal board_updated
signal game_lost
signal game_won

var _game_board: GameBoard
var _is_first_click:bool
var game_timer:Timer
var score:int

var flag_count: int:
	set(value):
		return
	get:
		return _game_board.flag_count

var visible_board_state:
	set(value):
		return
	get:
		return _game_board.visible_board_state

func initialise(configuration: GameStateConfiguration) -> void:
	_game_board = GameBoard.new()
	_game_board.initialise(configuration)
	
	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.timeout.connect(_on_timer_timeout)
	
	_is_first_click = true
	score = 0

func reset(configuration: GameStateConfiguration) -> void:
	_game_board.initialise(configuration)
	_is_first_click = true
	score = 0

func clear_cell(cell_index: int) -> bool:
	var is_safe = _game_board.on_clear(cell_index, _is_first_click)
	if _is_first_click == true:
		_is_first_click = false
		game_timer.start()
	
	if is_safe:
		board_updated.emit()
	else:
		_game_board.reveal()
		game_timer.stop()
		game_lost.emit()
		
	if _game_board.is_won():
		game_timer.stop()
		game_won.emit()
	
	return is_safe

func block_clear_cell(cell_index: int) -> bool:
	var is_safe = _game_board.on_block_clear(cell_index)
	if is_safe:
		board_updated.emit()
	else:
		_game_board.reveal()
		game_timer.stop()
		game_lost.emit()
		
	if _game_board.is_won():
		game_timer.stop()
		game_won.emit()
	
	return is_safe

func flag_cell(cell_index: int) -> void:
	_game_board.on_flag(cell_index)
	board_updated.emit()
	
func _on_timer_timeout():
	score = score + 1
	score_updated.emit()
