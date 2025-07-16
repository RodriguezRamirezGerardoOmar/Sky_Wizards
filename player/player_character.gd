extends CharacterBody3D

@export var MAX_SPEED: float = 80
@export var MIN_SPEED: float = 0
@export var acceleration: float = 15
@export var decceleration: float = 10
@export var current_speed: float = 50

@export var yaw_speed: float = 45
@export var roll_speed: float = 45
@export var pitch_speed: float = 45

var type_id = 1
var turn_input =  Vector2()
@export var dead: bool = false

@onready var missile = preload("res://missile/magic_missile.tscn")
@onready var sofa_mesh = $sofa2
@onready var audio = $AudioStreamPlayer3D
@onready var fire_audio = $fire_sound
@onready var label = $CanvasLayer/Label
@onready var life_component = $playerLifeBar
@onready var score_label = $CanvasLayer/score_label
@onready var background_fade = $CanvasLayer/background_fade
@onready var game_over = $CanvasLayer/background_fade/game_over

signal player_crashed
signal player_dead

func _ready() -> void:
	pitch_speed = deg_to_rad(pitch_speed)
	yaw_speed = deg_to_rad(yaw_speed)
	roll_speed = deg_to_rad(roll_speed)
	dead = false
	background_fade.visible = false
	game_over.visible = false

func _physics_process(delta: float) -> void:
	score_label.text = str(Score.amount)
	if Input.is_action_pressed("brake"):
		velocity = Vector3.ZERO
	label.text = (str(current_speed as int) + " m/s")
	if is_on_wall():
		life_component.current_health -= 10
	if audio.playing == false and dead == false:
		audio.play()
	if dead == false:
		var input = Input.get_vector("yaw_left","yaw_right","deccelerate","accelerate")
		var roll = Input.get_axis("roll_left","roll_right")
		if input.y > 0 and current_speed < MAX_SPEED:
			current_speed += acceleration * delta
		elif input.y < 0 and current_speed > MIN_SPEED:
			current_speed -= decceleration * delta
		velocity = basis.z * current_speed
		move_and_slide()
		var turn_dir = Vector3(-turn_input.y,-turn_input.x,-roll)
		apply_rotation(turn_dir,delta)
		turn_input = Vector2()
	else:
		velocity = Vector3.ZERO

func apply_rotation(vector,delta):
	rotate(basis.z,vector.z * roll_speed * delta)
	rotate(basis.x,vector.x * pitch_speed * delta)
	rotate(basis.y,vector.y * yaw_speed * delta)
	#lean mesh
	if vector.y < 0:
		sofa_mesh.rotation.z = lerp_angle(sofa_mesh.rotation.z, deg_to_rad(45)*-vector.y,delta)
	elif vector.y > 0:
		sofa_mesh.rotation.z = lerp_angle(sofa_mesh.rotation.z, deg_to_rad(-45)*vector.y,delta)
	else:
		sofa_mesh.rotation.z = lerp_angle(sofa_mesh.rotation.z, 0,delta)

func play_fire_audio() -> void:
	fire_audio.play()

func _on_control_analog_input(analog: Vector2) -> void:
	turn_input = analog

func _on_player_life_bar_player_dead() -> void:
	dead = true
	velocity = Vector3.ZERO
	sofa_mesh.visible = false
	player_dead.emit()
	audio.stop()
	background_fade.visible = true
	game_over.visible = true

func _on_control_fire_action() -> void:
	var staff_position = $lock_area.global_position
	var staff_rotation = $lock_area.global_rotation
	var staff_velocity = get_real_velocity()
	var proyectile = missile.instantiate()
	proyectile.position = staff_position
	proyectile.rotation = staff_rotation
	proyectile.linear_velocity = staff_velocity * 2
	add_sibling(proyectile)
	play_fire_audio()
