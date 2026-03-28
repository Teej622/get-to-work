extends StaticBody2D

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
	if is_visible_in_tree():
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = false
				
	else:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = true
