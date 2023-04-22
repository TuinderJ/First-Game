extends Control

@onready var player_inventory = $PlayerInventory

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int) -> void:
	var item = inventory_data.slot_datas[index]
	if item.quantity > 0: inventory_data.take_item(index)
