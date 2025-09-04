extends AttacksManager
class_name SnakeAttackManager

func _process(_delta: float) -> void:
	if enemy_instance.detected:
		snake_shoot()

func snake_shoot():
	for attack in attacks_list:
		if attack is ShootAttack:
			attack.attack()
