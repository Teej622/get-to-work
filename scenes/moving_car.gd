extends AnimatableBody2D

var speed = 100
var direction = Vector2.RIGHT
enum CarSprite {POLICE, RACE, SEDAN, SUV}
const CAR_COLORS = [
	Color(0.557, 0.557, 0.557, 1.0),
	Color(0.218, 0.643, 1.0, 1.0),
	Color(0.992, 0.254, 0.257, 1.0),
	Color(0.955, 0.519, 0.167, 1.0),
	Color(1.0, 1.0, 1.0, 1.0)
]
func _ready():
	var randSprite = randi() % 4
	$CarSprite.play(CarSprite.keys()[randSprite])
	
	if randSprite != CarSprite.POLICE:
		$CarSprite.modulate = CAR_COLORS[randi() % CAR_COLORS.size()]

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if(position.length()) > 5000:
		queue_free()
	if (direction.x > 0):
		$CarSprite.flip_h = true
	else:
		$CarSprite.flip_h = false
