extends Enemy
class_name Snake

@onready var shooting_attack: ShootingAttack = $shootingAttack

var hdr = 1.5

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	enemy_ready()
	animation.modulate = Color(hdr, hdr, hdr)

func _physics_process(delta: float) -> void:
	# update the Enemy class for this object
	update(delta)
	if detected and playerInSight:
		if shooting_attack:
			shooting_attack.attack()
		
	

	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		animation.play("idle")
		taking_damage = false

		
