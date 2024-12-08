extends InteractableObject

@export var itemName : String

func _interact():
	var item = load("res://Items/ItemData/" + itemName + ".tres")
	Globals.onGivePlayerItem.emit(item, 1)
	queue_free()
