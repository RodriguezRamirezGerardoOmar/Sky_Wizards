extends Control

@export var RADIUS = 70
@export var DEAD_ZONE = 0.1
@onready var camera = $"../../sofa2/SpringArm3D/Camera3D"
@onready var aim = $"../../SpringArm3D/Node3D"
var mouse_pos = Vector2()
var dead: bool = false
signal fire_action
signal analog_input(analog:Vector2)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	Input.warp_mouse(position)
	dead = false

func _process(_delta: float) -> void:
	if (!dead):
		if Input.is_action_just_pressed("fire"):
			fire_action.emit()
		if Input.is_action_just_pressed("ui_cancel"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			Input.warp_mouse(position)
			
		var local_mouse = get_local_mouse_position()
		if local_mouse.length() < RADIUS:
			mouse_pos = local_mouse
		else:
			mouse_pos = local_mouse.normalized() * RADIUS
			
		Input.warp_mouse(position+mouse_pos)
		
		var analog = Vector2(mouse_pos.x/RADIUS,-mouse_pos.y/RADIUS)
		
		if analog.length() > DEAD_ZONE:
			analog_input.emit(analog)
		queue_redraw()
	
func _draw() -> void:
	draw_arc(Vector2(0,0),RADIUS,0,360,40,Color.WHITE,5,true)
	draw_circle(Vector2(0,0),DEAD_ZONE*100,Color.RED)
	#draw_circle(camera.unproject_position(aim.position), 5, Color.GREEN)
	draw_circle(mouse_pos,10,Color.WHITE)


func _on_player_character_player_crashed() -> void:
	dead = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_player_life_bar_player_dead() -> void:
	dead = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
