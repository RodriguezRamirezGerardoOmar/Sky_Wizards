extends ProgressBar

func _ready() -> void:
	value = 100

func _on_player_character_player_crashed() -> void:
	value = 0
