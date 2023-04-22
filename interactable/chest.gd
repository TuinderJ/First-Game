extends StaticBody3D

@export var inventory_data: InventoryData

signal toggle_inventory(external_inventory_owner)

func player_interact() -> void:
	toggle_inventory.emit(self)
