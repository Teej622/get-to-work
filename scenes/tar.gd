extends Area2D

@onready var hamster_ball: RigidBody2D = get_node("/root/Game/HamsterBall")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("slowed!")
		hamster_ball.mass = 1.5
		hamster_ball.physics_material_override.friction = 1
		hamster_ball.physics_material_override.bounce = 0.35
		hamster_ball.strength = 10

func _process(delta: float) -> void:
	if is_visible_in_tree():
		monitoring = true
	else:
		monitoring = false
