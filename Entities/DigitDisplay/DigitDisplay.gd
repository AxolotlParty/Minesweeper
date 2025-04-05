extends Node2D

var value: int = -1;

@export var ones: Sprite2D
@export var tens: Sprite2D
@export var hundreds: Sprite2D

func _render():
	var str_value := str(clamp(value, 0, 999))
	var split_values := str_value.pad_zeros(3).split("")
	
	if split_values.size() < 3:
		push_error("Value must have at least 3 digits after padding.")
		return
	
	ones.frame = int(split_values[2])
	tens.frame  = int(split_values[1])
	hundreds.frame = int(split_values[0])
	
func set_value(new_value: int):
	value = new_value
	_render()

func increment():
	value = value + 1
	_render()

func decrement():
	value = value - 1
	_render()
