extends Area2D

# Redo as a texture button
signal game_restarted
@export var sprite: Sprite2D
var is_held: bool
var is_contained: bool

func _process(_delta) -> void:
	if Input.is_action_just_released("click"):
		is_held = false
		sprite.frame = 0
	
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		sprite.frame = 1
		is_held = true
		
	if event.is_action_released("click"):
		if is_held && is_contained:
			emit_signal("game_restarted")
		
		sprite.frame = 0
		is_held = false

func _on_mouse_entered() -> void:
	is_contained = true
	if is_held:
		sprite.frame = 1

func _on_mouse_exited() -> void:
	is_contained = false
	sprite.frame = 0
