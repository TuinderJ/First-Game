extends Control

@onready var player_inventory = $PlayerInventory
@onready var external_inventory = $ExternalInventory

signal add_item_to_hotbar(item: SlotData)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_external_inventory_data(external_inventory_owner) -> void:
	print(external_inventory_owner)

func on_inventory_interact(inventory_data: InventoryData, index: int) -> void:
	var item = inventory_data.slot_datas[index]
	var amount_to_transfer: int = 1
	
	if Input.is_action_pressed("shift"): amount_to_transfer = 10
	
	if item.quantity >= amount_to_transfer:
		add_item_to_hotbar.emit(item.item_data, amount_to_transfer)
		inventory_data.take_item(index, amount_to_transfer)
	elif item.quantity > 0:
		add_item_to_hotbar.emit(item.item_data, item.quantity)
		inventory_data.take_item(index, item.quantity)
