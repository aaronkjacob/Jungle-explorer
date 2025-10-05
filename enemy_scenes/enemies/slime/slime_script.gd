extends Enemy
class_name Slime

var hdr = 0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	enemy_ready()
	animation.modulate = Color(hdr, hdr+2, hdr)
	

func _physics_process(delta: float) -> void:
	# update the Enemy class for this object
	update(delta)
	
	
func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "hurt":
		animation.play("idle")
		taking_damage = false

		
