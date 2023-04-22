extends Resource
class_name InventoryData

@export var slot_datas: Array[SlotData]

signal inventory_interact(inventory_data: InventoryData, index: int)
signal inventory_updated(inventory_data: InventoryData, index: int)

func on_slot_clicked(index: int) -> void:
	inventory_interact.emit(self, index)

func take_item(index: int) -> SlotData:
	var slot_data: SlotData = slot_datas[index]
	
	if not slot_data: return null
	
	if slot_datas[index].quantity > 0:
		slot_datas[index].quantity -= 1
		inventory_updated.emit(self)
	
	return slot_data
