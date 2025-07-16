extends CharacterBody3D

@export var speed: float = 25
@export var yaw_speed: float = 30
@export var roll_speed: float = 30
@export var pitch_speed: float = 30

var type_id = 2
var tracking_player: bool = false
var boids = []

@onready var missile = preload("res://missile/magic_missile.tscn")
@onready var cauldron = $cauldron
@onready var enemy = $"."
@onready var world = enemy.get_parent()
@onready var player: Node3D
@onready var timer = $despawn_timer
@onready var audio = $flyby_sound
@onready var fire_audio = $fire_sound
@onready var missile_area = $cauldron/red_wizard/missile_area
@onready var score = preload("res://score.gd")

signal increase_score

func play_fire_audio() -> void:
	fire_audio.play()

func _ready() -> void:
	pitch_speed = deg_to_rad(pitch_speed)
	yaw_speed = deg_to_rad(yaw_speed)
	roll_speed = deg_to_rad(roll_speed)

func _physics_process(delta: float) -> void:
	if is_on_wall():
		Score.amount += 1 
		queue_free()
	if tracking_player:
		var player_position = player.position
		var target = (player_position - position).normalized()
		velocity = target * speed
	else:
		velocity = basis.z * speed
	move_and_slide()

func _on_missile_area_body_entered(body: Node3D) -> void:
	if body.has_node("player_marker"):
		tracking_player = true
		player = body
		audio.play()
		timer.stop()
	#elif body.has_node("enemy_marker"):
	#	boids.append(body)

func _on_missile_area_body_exited(body: Node3D) -> void:
	if body.has_node("player_marker"):
		tracking_player = false
		timer.start()
	#elif body.has_node("enemy_marker"):
	#	boids.erase(body)

func _on_fire_timer_timeout() -> void:
	if tracking_player:
		var staff_position = missile_area.global_position
		var staff_rotation = missile_area.global_rotation
		var staff_velocity = get_real_velocity()
		var proyectile = missile.instantiate()
		proyectile.position = staff_position
		proyectile.rotation = staff_rotation
		proyectile.linear_velocity = staff_velocity * 2
		add_sibling(proyectile)
		play_fire_audio()

func _on_despawn_timer_timeout() -> void:
	queue_free()
