extends AnimatableBody2D

var speed = 100
var direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if(position.length()) > 5000:
		queue_free()
