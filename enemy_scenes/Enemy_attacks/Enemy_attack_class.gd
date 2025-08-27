extends Node
class_name EnemyAttacks

func _ready() -> void:
	if get_parent() is not AttacksManager:
		printerr(" enemy_attack is not a child of attacks_manager")
		queue_free()
		
func attack():
	printerr("attack function has no overide")
