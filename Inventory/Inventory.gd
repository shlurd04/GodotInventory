class_name Inventory
extends Node

var slots : Array[InventorySlot]

@onready var window : Panel = get_node("InventoryWindow")
@onready var infoText : Label = get_node("InventoryWindow/InfoText")

@export var starterItems : Array[Item]

func _ready() -> void:
	toggleWindow(false)
	
	for child in get_node("InventoryWindow/SlotContainer").get_children():
		slots.append(child)
		child.setItem(null)
		child.inventory = self
		
	Globals.onGivePlayerItem.connect(onGivePlayerItem)
	
	for item in starterItems:
		addItem(item)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		toggleWindow(!window.visible)

func toggleWindow(open : bool):
	window.visible = open
	
	if open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func onGivePlayerItem(item : Item, amount : int):
	for i in range(amount):
		addItem(item)

func addItem(item : Item):
	var slot = getSlotToAdd(item)
	
	if slot == null:
		return
	
	if slot.item == null:
		slot.setItem(item)
	elif slot.item == item:
		slot.addItem()

func removeItem(item : Item):
	var slot = getSlotToRemove(item)
	
	if slot == null or slot.item == null:
		return
	
	slot.removeItem()

func getSlotToAdd(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.quantity < item.maxStackSize:
			return slot
			
	for slot in slots:
		if slot.item == null:
			return slot
	
	return null

func getSlotToRemove(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item:
			return slot
	
	return null

func getNumberOfItem(item : Item) -> int:
	var total = 0
	
	for slot in slots:
		if slot.item == item:
			total += slot.quantity
	
	return total
	
