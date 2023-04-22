extends CharacterBody3D

@export var inventory_data: InventoryData
@export var hotbar_data: InventoryData

@onready var player := $Pivot
@onready var camera := $Pivot/Camera3D
@onready var health_bar := $"../UI/Hud/HealthBar"
@onready var hotbar := $"../UI/Hud/Hotbar"
@onready var coin_counter := $"../UI/Hud/Hotbar/DeckedOutCoinSlot/DeckedOutCoinCounter"

var hotbar_texture := preload("res://assets/hotbar.png")
var active_hotbar_texture := preload("res://assets/active_hotbar.png")

# Movement
const JUMP_VELOCITY:float = 9.33
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity := Vector3.ZERO
var speed: float = 4.317
var speed_modifier: float = 1
var movement_enabled: bool = true
var sprinting: bool = false
var sneaking: bool = false

var mouse_sensitivity: float = .75
var desired_fov: float = 75
var current_fov: float
var previous_active_hotbar_slot: int = 0
var desired_active_hotbar_slot:  int = 0
var active_hotbar_slot: int = 0
var first_hotbar_slot: int = 0
var last_hotbar_slot: int = 6
var health: int = 20
var coins: int = 0

signal toggle_inventory()
signal toggle_hud()
signal update_health()
signal set_active_hotbar_slot(slot_number: int)
signal toggle_debug()
signal update_debug()

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	# Mouse Movement
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player.rotate_y(-event.relative.x * 0.01 * mouse_sensitivity)
			camera.rotate_x(-event.relative.y * 0.01 * mouse_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# Hotbar
	if Input.is_action_pressed("cycle_item_left"):
		desired_active_hotbar_slot = active_hotbar_slot - 1
		if active_hotbar_slot <= first_hotbar_slot: desired_active_hotbar_slot = last_hotbar_slot
		select_active_hotbar_slot(desired_active_hotbar_slot)
	if Input.is_action_pressed("cycle_item_right"):
		desired_active_hotbar_slot = active_hotbar_slot + 1
		if active_hotbar_slot >= last_hotbar_slot: desired_active_hotbar_slot = first_hotbar_slot
		select_active_hotbar_slot(desired_active_hotbar_slot)
	if Input.is_action_just_pressed("select_hotbar_1"): select_active_hotbar_slot(0)
	if Input.is_action_just_pressed("select_hotbar_2"): select_active_hotbar_slot(1)
	if Input.is_action_just_pressed("select_hotbar_3"): select_active_hotbar_slot(2)
	if Input.is_action_just_pressed("select_hotbar_4"): select_active_hotbar_slot(3)
	if Input.is_action_just_pressed("select_hotbar_5"): select_active_hotbar_slot(4)
	if Input.is_action_just_pressed("select_hotbar_6"): select_active_hotbar_slot(5)
	if Input.is_action_just_pressed("select_hotbar_7"): select_active_hotbar_slot(6)
	
	# Inventory Toggle
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	# Debug Toggle
	if Input.is_action_just_pressed("debug_screen"):
		toggle_debug.emit()

func _physics_process(delta) -> void:
	var input_direction := Input.get_vector("move_left","move_right","move_forward","move_back")
	var direction = (player.transform.basis * Vector3(input_direction.x, 0, input_direction.y))
	
	update_debug.emit(self)
	
	# Testing
	if Input.is_action_just_pressed("test_q"):
		toggle_hud.emit()
	
	# Sprinting
	if Input.is_action_pressed("sprint") and input_direction.y < 0: sprinting = true
	
	# Sneaking
	if Input.is_action_pressed("sneak"):
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
	health -= damage
	if health <= 0:
		health = 0
		# gameover
	health_changed(health)

func health_changed(health_value) -> void:
	health_bar.value = health_value

func select_active_hotbar_slot(desired_slot) -> void:
	hotbar.get_children()[previous_active_hotbar_slot].set_texture(hotbar_texture)
	hotbar.get_children()[desired_slot].set_texture(active_hotbar_texture)
	previous_active_hotbar_slot = desired_slot
	active_hotbar_slot = desired_slot

func gain_coins(coins_gained) -> void:
	if coins + coins_gained > 999: coins = 999
	coins += coins_gained
	coin_counter.text = str(coins)

func spend_coins(coins_lost) -> bool:
	if coins - coins_lost < 0: return false
	coins -= coins_lost
	coin_counter.text = str(coins)
	return true

func disable_movement() -> void:
	movement_enabled = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func enable_movement() -> void:
	movement_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
