extends EnemyProjectile
class_name PoisonBall

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var hdr = 1.5

func _ready() -> void:
	sprite_2d.modulate = Color(hdr+3.5, hdr, hdr)
