extends Control

@onready var hotbar = $Hotbar

func set_hotbar_inventory_data(inventory_data: InventoryData) -> void:
	hotbar.set_inventory_data(inventory_data, true)
