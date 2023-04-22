extends CharacterBody3D

@export var inventory_data: InventoryData
@export var hotbar_data: InventoryData

@onready var player := $Pivot
@onready var camera := $Pivot/Camera3D
@onready var interact_ray = $Pivot/Camera3D/InteractRay

# Movement
const JUMP_VELOCITY:float = 9.33
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity := Vector3.ZERO
var speed: float = 4.317
var speed_modifier: float = 1
var movement_enabled: bool = true
var time_last_pressed_forward: int = true
var sprinting: bool = false
var sneaking: bool = false

var mouse_sensitivity: float = .75
var desired_fov: float = 75
var current_fov: float
var max_health: int = 20
var health: int = 20
var coins: int = 0

signal toggle_inventory()
signal toggle_hud()
signal update_health()
signal toggle_debug()
signal update_debug()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	# Mouse Movement
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player.rotate_y(-event.relative.x * 0.01 * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * 0.01 * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Sprint on double tap
	if Input.is_action_just_pressed("move_forward"):
		var time_pressed = Time.get_ticks_msec()
		if time_pressed - time_last_pressed_forward <= 250: sprinting = true
		time_last_pressed_forward = time_pressed
	
	# Inventory Toggle
	if Input.is_action_just_pressed("inventory"):
		interact()
	
	# Debug Toggle
	if Input.is_action_just_pressed("debug_screen"):
		toggle_debug.emit()

func _physics_process(delta) -> void:
	var input_direction := Input.get_vector("move_left","move_right","move_forward","move_back")
	var direction = (player.transform.basis * Vector3(input_direction.x, 0, input_direction.y))
	
	update_debug.emit(self)
	
	# Testing
	if Input.is_action_just_pressed("test_q"):
		heal(1)
	
	# Sprinting
	if Input.is_action_pressed("sprint") and input_direction.y < 0 and movement_enabled: sprinting = true
	
	# Sneaking
	if Input.is_action_pressed("sneak") and movement_enabled:
		sneaking = true
		sprinting = false
	else:
		sneaking = false
	
	# Stop Sprinting if standing still
	if input_direction.y >= 0: sprinting = false
	
	if sneaking:
		speed_modifier = 0.3
		desired_fov = 73
	elif sprinting:
		speed_modifier = 1.3
		desired_fov = 85
	else:
		speed_modifier = 1
		desired_fov = 75
	
	# Gravity
	if not is_on_floor():
		target_velocity.y = (target_velocity.y - (gravity * delta)) * .98
	else:
		target_velocity.y = 0
	
	# Ground Velocity
	if direction and movement_enabled:
		target_velocity.x = direction.x * speed * speed_modifier
		target_velocity.z = direction.z * speed * speed_modifier
	else:
		target_velocity.x = move_toward(target_velocity.x, 0, speed)
		target_velocity.z = move_toward(target_velocity.z, 0, speed)
	
	# Jump Velocity
	if is_on_floor() and Input.is_action_pressed("jump") and movement_enabled: target_velocity.y = JUMP_VELOCITY
	
	# Moving the Character
	camera.fov = lerpf(camera.fov, desired_fov, 0.2)
	velocity = target_velocity
	move_and_slide()

func receive_damage(damage) -> void:
	if health - damage < 0:
		health = 0
	else:
		health -= damage
	update_health.emit(health)

func heal(value) -> void:
	if health + value > max_health:
		health = max_health
	else:
		health += value
	update_health.emit(health)

func spend_coins(coins_lost) -> void:
	pass

func disable_movement() -> void:
	movement_enabled = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func enable_movement() -> void:
	movement_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func interact() -> void:
	if interact_ray.is_colliding():
		interact_ray.get_collider().player_interact()
	else:
		toggle_inventory.emit()
