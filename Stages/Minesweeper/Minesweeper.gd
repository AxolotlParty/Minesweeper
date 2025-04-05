extends Node2D

@onready var game_state: GameState = GameState.new()
@onready var score_display = $ScoreDisplay
@onready var mine_display = $MineDisplay
@onready var mine_field = $MineField
@onready var face = $Face/Area2D # Find a better way to connect these?
@onready var game_lost_sfx = $GameOverSound
@onready var game_won_sfx = $GameWonSound
@onready var click_sfx = $ClickSound

func _ready() -> void:
	var configuration = GameStateConfiguration.new()
	game_state.initialise(configuration)
	mine_field.initialise(Vector2i(configuration.columns, configuration.rows))
	add_child(game_state.game_timer)
	
	game_state.score_updated.connect(_on_score_updated)
	game_state.board_updated.connect(_on_board_updated)
	game_state.game_lost.connect(_on_game_lost)
	game_state.game_won.connect(_on_game_won)
	face.game_restarted.connect(_on_restart_game)
	mine_field.minefield_primary_triggered.connect(_on_minefield_primary_triggered)
	mine_field.minefield_secondary_triggered.connect(_on_minefield_secondary_triggered)
	mine_field.minefield_tertiary_triggered.connect(_on_minefield_tertiary_triggered)
	
	mine_display.set_value(game_state.flag_count)
	score_display.set_value(game_state.score)
	mine_field.update_state(game_state.visible_board_state)

func _on_restart_game():
	var configuration = GameStateConfiguration.new()
	game_state.reset(configuration)
	mine_display.set_value(game_state.flag_count)
	score_display.set_value(game_state.score)
	mine_field.update_state(game_state.visible_board_state)

func _on_score_updated() -> void:
	score_display.set_value(game_state.score)

func _on_minefield_primary_triggered(cell: int) -> void:
	var is_safe = game_state.clear_cell(cell)
	if is_safe:
		click_sfx.play()
	
func _on_minefield_secondary_triggered(cell: int) -> void:
	game_state.flag_cell(cell)

func _on_minefield_tertiary_triggered(cell: int) -> void:
	var is_safe = game_state.block_clear_cell(cell)
	if is_safe:
		click_sfx.play()
		
func _on_board_updated() -> void:
	mine_field.update_state(game_state.visible_board_state)
	mine_display.set_value(game_state.flag_count)
	
func _on_game_lost() -> void:
	game_lost_sfx.play()
	#TODO: Sad Face
	mine_field.update_state(game_state.visible_board_state)
	
func _on_game_won() -> void:
	game_won_sfx.play()
	#TODO: Happy Face
	mine_field.update_state(game_state.visible_board_state)
