extends Node2D

signal score
@onready var animated_goal = %AnimatedGoal

func _physics_process(delta: float) -> void:
	animated_goal.play("Waving")

func _on_area_2d_body_entered(body: Node2D) -> void:
	score.emit()
	
