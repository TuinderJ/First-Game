extends PanelContainer

const Slot = preload("res://inventory/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData, hotbar: bool = false) -> void:
	if hotbar:
		for slot in inventory_data.slot_datas:
			slot.hotbar_slot = true
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
	pass
