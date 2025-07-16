extends Node3D
var randomizer = RandomNumberGenerator.new()
@export var enemy: PackedScene
@onready var timer = $Timer
@onready var player = get_parent().get_node("PlayerCharacter")

func _ready() -> void:
	timer.wait_time = randomizer.randf_range(1,5)
	timer.start()	

func _process(_delta: float) -> void:
	if timer.is_stopped() and player.dead == false:
		timer.wait_time = randomizer.randf_range(1,5)
		timer.start()

func _on_timer_timeout() -> void:
	var cauldron_rotation = randomizer.randf_range(0,360)
	var mob = enemy.instantiate()
	mob.position = position
	mob.rotation.y = deg_to_rad(cauldron_rotation)
	add_sibling(mob)

func _on_player_character_player_dead() -> void:
	timer.stop()
