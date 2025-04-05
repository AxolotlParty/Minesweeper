extends Node2D

signal minefield_primary_triggered(cell_index: int)
signal minefield_secondary_triggered(cell_index: int)
signal minefield_tertiary_triggered(cell_index: int)

var cell_scene = load("res://Entities/Cell/Cell.tscn")
var cells = []

func initialise(configuration: Vector2i) -> void:
	for index in range(configuration.x*configuration.y):
		var cell = cell_scene.instantiate()
		cell.set_index(index)
		cell.cell_primary_triggered.connect(_on_cell_primary_triggered)
		cell.cell_secondary_triggered.connect(_on_cell_secondary_triggered)
		cell.cell_tertiary_triggered.connect(_on_cell_tertiary_triggered)
		cells.append(cell)
		add_child(cell)
	
func update_state(state) -> void:
	for index in range(state.size()):
		cells[index].set_state(state[index])

func _on_cell_primary_triggered(cell_index: int) -> void:
	minefield_primary_triggered.emit(cell_index)

func _on_cell_secondary_triggered(cell_index: int) -> void:
	minefield_secondary_triggered.emit(cell_index)

func _on_cell_tertiary_triggered(cell_index: int) -> void:
	minefield_tertiary_triggered.emit(cell_index)
