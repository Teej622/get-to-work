extends Label
@onready var hamster_ball = get_node("/root/Game/HamsterBall")
func _physics_process(delta: float) -> void:
	text = str(hamster_ball.shots)
