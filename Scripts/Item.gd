class_name Item
extends Resource

@export var displayName : String
@export var icon : Texture2D
@export var maxStackSize : int = 12
@export var worldItemScene : PackedScene

func onUse(player) -> bool:
	print("Use")
	return false
