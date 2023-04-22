extends Resource
class_name SlotData

const MAX_STACK_SIZE: int = 999

@export var item_data: ItemData
@export_range(0, MAX_STACK_SIZE) var quantity: int = 0: set = set_quantity

var hotbar_slot: bool = false
var active_hotbar_slot: bool = false

func set_quantity(value: int) -> void:
	quantity = value
	if quantity > 1 and not item_data.stackable:
		quantity = 1
		push_error("%s is not stackable, stting quantity to 1" % item_data.name)
