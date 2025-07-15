extends Node

@export var input: Vector2 = Vector2.ZERO

signal input_detected

func _process(delta: float) -> void:
	input = Input.get_vector("yaw_left", "yaw_right", "accelerate", "deccelerate")
	input_detected.emit(input)
	print(input)
