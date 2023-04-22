extends PanelContainer

const Slot = preload("res://inventory/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData, hotbar: bool = false) -> void:
	if hotbar:
		for i in range(inventory_data.slot_datas.size()):
			inventory_data.slot_datas[i].hotbar_slot = true
		inventory_data.slot_datas[0].active_hotbar_slot = true
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func populate_item_grid(inventory_data: InventoryData) -> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
	
		if slot_data:
			slot.set_slot_data(slot_data)

func update_active_hotbar_slot(inventory_data: InventoryData, desired_active_hotbar_slot: int) -> void:
	for i in range(inventory_data.slot_datas.size()):
		if i == desired_active_hotbar_slot:
			inventory_data.slot_datas[i].active_hotbar_slot = true
		else:
			inventory_data.slot_datas[i].active_hotbar_slot = false
	populate_item_grid(inventory_data)

func get_active_hotbar_slot(inventory_data: InventoryData) -> int:
	for i in range(inventory_data.slot_datas.size()):
		if inventory_data.slot_datas[i].active_hotbar_slot:
			return i
	return -1
