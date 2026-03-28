extends Node2D

signal score
@onready var animated_goal = %AnimatedGoal

func _physics_process(delta: float) -> void:
	animated_goal.play("Waving")
	
	if is_visible_in_tree():
		%Area2D.process_mode = Node.PROCESS_MODE_ALWAYS
				
	else:
		%Area2D.process_mode = Node.PROCESS_MODE_DISABLED
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	score.emit()	
