class_name InventorySlot
extends Node

var item : Item
var quantity : int
var inventory : Inventory

@onready var icon : TextureRect = get_node("Icon")
@onready var quantityText : Label = get_node("QuantityText")

func setItem(newItem : Item):
	item = newItem
	quantity = 1
	
	if item == null:
		icon.visible = false
	else:
		icon.visible = true
		icon.texture = item.icon
	
	updateQuantityText()

func addItem():
	quantity += 1
	updateQuantityText()

func removeItem():
	quantity -= 1
	updateQuantityText()
	
	if quantity == 0:
		setItem(null)

func updateQuantityText():
	if quantity <= 1:
		quantityText.text = ""
	else:
		quantityText.text = str(quantity)

func _on_mouse_entered() -> void:
	if item == null:
		inventory.infoText.text = ""
	else:
		inventory.infoText.text = item.displayName


func _on_mouse_exited() -> void:
	inventory.infoText.text = ""


func _on_pressed() -> void:
	if item == null:
		return
	
	var removeAfterUse = item.onUse(inventory.get_parent())
	
	if removeAfterUse:
		removeItem()

func dropItem():
	if item == null:
		return
	
	var worldItem = item.worldItemScene.instantiate()
	add_child(worldItem)
	worldItem.position = inventory.get_parent().position + Vector3(0, 1.5, 0) - inventory.get_parent().basis.z
	removeItem()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			dropItem()
