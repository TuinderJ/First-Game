extends Node3D

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
@onready var hud = $UI/Hud
@onready var debug_screen = $UI/DebugScreen
@onready var coordinate_x = $"UI/DebugScreen/GridContainer/MarginContainer/Coordinate X"
@onready var coordinate_y = $"UI/DebugScreen/GridContainer/MarginContainer2/Coordinate Y"
@onready var coordinate_z = $"UI/DebugScreen/GridContainer/MarginContainer3/Coordinate Z"

var first_hotbar_slot: int = 0
var last_hotbar_slot: int = 6
var previous_active_hotbar_slot: int = 0
var desired_active_hotbar_slot: int = 0
var active_hotbar_slot: int = 0

func _ready() -> void:
	hud.set_hotbar_inventory_data(player.hotbar_data)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	
	player.toggle_inventory.connect(toggle_inventory_interface)
	player.update_debug.connect(update_debug_interface)
	player.toggle_debug.connect(toggle_debug_interface)
	player.set_active_hotbar_slot.connect(on_set_active_hotbar_slot)
	inventory_interface.add_item_to_hotbar.connect(on_add_item_to_hotbar)

func on_add_item_to_hotbar(item_data: ItemData, amount_to_increase: int) -> void:
	hud.increase_item_quantity(player.hotbar_data, item_data, amount_to_increase)

func on_set_active_hotbar_slot(index: int) -> void:
	pass

func toggle_inventory_interface() -> void:
	inventory_interface.visible = not inventory_interface.visible
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.movement_enabled = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.movement_enabled = true

func toggle_debug_interface() -> void:
	debug_screen.visible = not debug_screen.visible

func update_debug_interface(source) -> void:
	coordinate_x.text = "Coordinate X: %s" % snapped(source.global_transform.origin.x, 0.01)
	coordinate_y.text = "Coordinate Y: %s" % snapped(source.global_transform.origin.y, 0.01)
	coordinate_z.text = "Coordinate Z: %s" % snapped(source.global_transform.origin.z, 0.01)

func _unhandled_input(event) -> void:
	if Input.is_action_just_pressed("exit"): get_tree().quit()
	# Hotbar
	if Input.is_action_pressed("cycle_item_left"):
		desired_active_hotbar_slot = active_hotbar_slot - 1
		if active_hotbar_slot <= first_hotbar_slot: desired_active_hotbar_slot = last_hotbar_slot
		hud.set_active_hotbar_slot(desired_active_hotbar_slot)
	if Input.is_action_pressed("cycle_item_right"):
		desired_active_hotbar_slot = active_hotbar_slot + 1
		if active_hotbar_slot >= last_hotbar_slot: desired_active_hotbar_slot = first_hotbar_slot
		hud.set_active_hotbar_slot(desired_active_hotbar_slot)
	if Input.is_action_just_pressed("select_hotbar_1"): hud.set_active_hotbar_slot(0)
	if Input.is_action_just_pressed("select_hotbar_2"): hud.set_active_hotbar_slot(1)
	if Input.is_action_just_pressed("select_hotbar_3"): hud.set_active_hotbar_slot(2)
	if Input.is_action_just_pressed("select_hotbar_4"): hud.set_active_hotbar_slot(3)
	if Input.is_action_just_pressed("select_hotbar_5"): hud.set_active_hotbar_slot(4)
	if Input.is_action_just_pressed("select_hotbar_6"): hud.set_active_hotbar_slot(5)
	if Input.is_action_just_pressed("select_hotbar_7"): hud.set_active_hotbar_slot(6)
