extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel
@onready var panel = $MarginContainer/Panel

signal slot_clicked(index: int)

func set_slot_data(slot_data: SlotData) -> void:
	var item_data = slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if slot_data.quantity > 0:
		quantity_label.text = "%s" % slot_data.quantity
		quantity_label.show()
	
	if slot_data.active_hotbar_slot:
		panel.show()
	else:
		panel.hide()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		# Remove from target inventory and put into the player's inventory
		slot_clicked.emit(get_index())
