extends CharacterBody2D
class_name Enemy

# line of sight, detection area, and detected: all variables that check if the Enemy should follow the player
var inLineOfSight = false
var inDetectionArea = false
var detected = false

# player instance and position
@onready var player_instance: Player = %Player
var player_pos : Vector2

# the state of the Enemy, (idle, chasing, attacking)
var current_state = "idle"

# taking damage bool
var taking_damage = false

# detection area and enemy node
var detection_area: Area2D
var enemy_obj : Enemy


# in this class the enemy the parameters are referring to is the slime, globlin, scout. (the enemy of the player)


func idle(enemy_object: Enemy):
	# stay still
	# idle animation
	
	if taking_damage == false:
		enemy_object.direction = Vector2.ZERO
		enemy_object.animation.play("idle")
	
func chase(enemy_object: Enemy):
	enemy_object.direction = enemy_object.position.direction_to(player_pos)
	
	
func check_for_line_of_sight(target_pos: Vector2, _enemy_object: Enemy, line_of_sight: RayCast2D):
	#make the raycast target the player
	var local_target = line_of_sight.to_local(target_pos)
	line_of_sight.set_target_position(local_target)
	
	var line_of_sight_colliders = line_of_sight.get_collider()
	if line_of_sight_colliders is Player:
		return true
	else:
		return false
		
func check_for_in_detection_area():
	# check if we should chase the player
	var detection_body_collisions = detection_area.get_overlapping_bodies()
	for body in detection_body_collisions:
		if body is Player:
			inDetectionArea = true
		else:
			pass
func check_for_transition(enemy_object: CharacterBody2D):
	check_for_in_detection_area()
			
	if inDetectionArea or detected:	
		inLineOfSight = check_for_line_of_sight(player_pos, enemy_object, enemy_object.line_of_sight_ray)
	if inDetectionArea and inLineOfSight:
		detected = true
	else:
		detected = false

	if detected:
		current_state = "chase"
	elif detected == false:
		current_state = "idle"

func damage(attack: Attack, _enemy):
	velocity += (global_position - attack.position).normalized()*attack.knockback_force
	taking_damage = true

func handle_animation_flip():
	if self.direction.x:
		if self.direction.x < 0:
			self.animation.flip_h = true
		elif self.direction.x > 0:
			self.animation.flip_h = false

func _ready() -> void:
	for child in get_children():
		if child is Area2D and child.name == "detection_area":
			detection_area = child

	if self is Enemy:
		enemy_obj = self

func update(_delta: float) -> void:
	player_pos = player_instance.global_position
	
	if current_state == "idle":
		idle(enemy_obj)
	elif current_state == "chase":
		chase(enemy_obj)
				
	handle_animation_flip()
			
	check_for_transition(enemy_obj)
