extends Node

@export var MAX_HEALTH: int = 100
@export var current_health: int = 100

@onready var life_bar = $"../CanvasLayer/ProgressBar"

signal player_dead

func _ready() -> void:
	current_health = 100

func _process(_delta: float) -> void:
	life_bar.value = current_health
	if current_health <= 0:
		player_dead.emit()

func _on_player_character_player_hurt(amount: int) -> void:
	current_health -= amount
