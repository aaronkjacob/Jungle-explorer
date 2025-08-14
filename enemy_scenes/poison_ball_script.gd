extends Node2D
class_name PoisonBall

const speed = 200


func _process(delta: float) -> void:
	position += transform.x * speed * delta
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
