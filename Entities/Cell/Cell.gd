extends Node2D

signal cell_primary_triggered(cell_index: int)
signal cell_secondary_triggered(cell_index: int)
signal cell_tertiary_triggered(cell_index: int)

@onready var button = $Button
var index: int
var state: int

func set_index(cell_index: int) -> void:
	state = 0
	index = cell_index
	position.x = (index / 8) * 16
	position.y = (index % 8) * 16
	
func set_state(cell_state: int) -> void:
	if(cell_state == state):
		return
	
	state = cell_state
	match cell_state:
		0:
			button.disabled = false
			button.texture_normal.region = Rect2(Vector2i((cell_state % 8)*16, (cell_state / 8)*16), Vector2i(16, 16))
			button.texture_pressed.region = Rect2(Vector2i((cell_state+1 % 8)*16, (cell_state+1 / 8)*16), Vector2i(16, 16))
		3:
			button.disabled = false
			button.texture_normal.region = Rect2(Vector2i((cell_state % 8)*16, (cell_state / 8)*16), Vector2i(16, 16))
			button.texture_pressed.region = Rect2(Vector2i(64, 0), Vector2i(16, 16))
		1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15:
			button.disabled = true
			button.texture_disabled.region = Rect2(Vector2i((cell_state % 8)*16, (cell_state / 8)*16), Vector2i(16, 16))

func _on_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				cell_secondary_triggered.emit(index)
		match event.button_index:
			MOUSE_BUTTON_MIDDLE:
				cell_tertiary_triggered.emit(index)

func _on_button_pressed() -> void:
	cell_primary_triggered.emit(index)
