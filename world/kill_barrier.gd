extends Node3D

var type_id = 3

signal player_hurt(amount)

func _process(_delta: float) -> void:
	pass

func _on_player_character_player_crashed() -> void:
	player_hurt.emit(100)
	
