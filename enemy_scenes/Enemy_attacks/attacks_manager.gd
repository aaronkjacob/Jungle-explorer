extends Node
class_name AttacksManager

var enemy_instance : Enemy
var attacks_list = []

func _ready() -> void:
	if get_parent() is Enemy:
		enemy_instance = get_parent()
		
	for child in get_children():
		if child is EnemyAttacks:
			attacks_list.append(child)
