extends Control

@onready var hotbar = $Hotbar
@onready var health_bar = $HealthBar

func update_health(value: int) -> void:
	health_bar.value = value

func set_hotbar_inventory_data(inventory_data: InventoryData) -> void:
	hotbar.set_inventory_data(inventory_data, true)

func set_active_hotbar_slot(inventory_data: InventoryData, desired_active_hotbar_slot: int) -> void:
	hotbar.update_active_hotbar_slot(inventory_data, desired_active_hotbar_slot)

func get_active_hotbar_slot(inventory_data: InventoryData) -> int:
	return hotbar.get_active_hotbar_slot(inventory_data)

func increase_hotbar_item_quantity(inventory_data: InventoryData, item_data: ItemData, amount_to_increase: int = 1) -> void:
	var index = find_item_index(inventory_data, item_data)
	if index == -1: return
	inventory_data.slot_datas[index].quantity += amount_to_increase
	hotbar.populate_item_grid(inventory_data)

func find_item_index(inventory_data: InventoryData, item_data:ItemData) -> int:
	for i in range(inventory_data.slot_datas.size()):
		if inventory_data.slot_datas[i].item_data.name == item_data.name: return i
	return -1
