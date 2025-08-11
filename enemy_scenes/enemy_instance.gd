extends Enemy
class_name Slime

@onready var line_of_sight_ray: RayCast2D = $RayCast2D


@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

var current_state = "idle"

var direction: Vector2
@export var speed = 3000

func _physics_process(delta: float) -> void:
	update(delta, self)
	
	velocity = direction * speed * delta

	move_and_slide()
