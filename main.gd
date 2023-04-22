extends Node3D

@onready var player = $Player
@onready var inventory_interface = $UI/InventoryInterface
@onready var hud = $UI/Hud
@onready var debug_screen = $UI/DebugScreen
@onready var coordinate_x = $"UI/DebugScreen/GridContainer/MarginContainer/Coordinate X"
@onready var coordinate_y = $"UI/DebugScreen/GridContainer/MarginContainer2/Coordinate Y"
@onready var coordinate_z = $"UI/DebugScreen/GridContainer/MarginContainer3/Coordinate Z"

func _ready() -> void:
	player.toggle_inventory.connect(toggle_inventory_interface)
	player.update_debug.connect(update_debug_interface)
	player.toggle_debug.connect(toggle_debug_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)
	hud.set_hotbar_inventory_data(player.hotbar_data)

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
