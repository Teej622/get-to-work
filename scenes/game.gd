extends Node2D

@onready var hamster_ball = %HamsterBall
@onready var scoreType = %ScoreType
@export var par = [4, 2, 2, 2]
var stage = 0
var shot_history = []
var starting_pos = [Vector2(90,80), Vector2(), Vector2(), Vector2()]

func _physics_process(delta: float) -> void:
	
	%ShotCounter.text = str(hamster_ball.shots)
	%Par.text = "Par: " + str(par[stage])
	
	if Input.is_action_pressed("retry") and %ScoreScreen.visible == false:
		stage_handler()
		
	

func _on_goal_score() -> void:
	print("score")
	if hamster_ball.shots > par[stage] + 3:
		scoreType.text = str(hamster_ball.shots) + " over par..."
	elif hamster_ball.shots == par[stage] + 3:
		scoreType.text = "Triple Bogey\n(" + str(hamster_ball.shots - par[stage]) +" over par)"
	elif hamster_ball.shots == par[stage] + 2:
		scoreType.text = "Double Bogey\n(" + str(hamster_ball.shots - par[stage]) +" over par)"
	elif hamster_ball.shots == par[stage] + 1:
		scoreType.text = "Bogey\n(" + str(hamster_ball.shots - par[stage]) +" over par)"
	elif hamster_ball.shots == 1:
		scoreType.text = "Hole in One!"
	elif hamster_ball.shots == par[stage]:
		scoreType.text = "Par"
	elif hamster_ball.shots == par[stage] - 1:
		scoreType.text = "Birdie!\n(" + str(par[stage] - hamster_ball.shots) +" under par)"
	elif hamster_ball.shots == par[stage] - 2:
		scoreType.text = "Eagle!\n(" + str(par[stage] - hamster_ball.shots) +" under par)"
	elif hamster_ball.shots == par[stage] - 3:
		scoreType.text = "Albatross!\n(" + str(par[stage] - hamster_ball.shots) +" under par)"
	elif hamster_ball.shots <= par[stage] - 4:
		scoreType.text = "Holy F$%k!\n(" + str(par[stage] - hamster_ball.shots) +" under par)"
	
	print(hamster_ball.shots)

	%ScoreScreen.visible = true
	


func _on_next_stage_btn_pressed() -> void:
	stage += 1
	if stage > 4:
		#TODO if stage count is higher than current stages it should do something
		pass
	%ScoreScreen.visible = false
	shot_history.append(hamster_ball.shots)
	shot_counter_update()
	stage_handler()
	
func _on_retry_btn_pressed() -> void:
	%ScoreScreen.visible = false
	shot_counter_update()
	stage_handler()

func shot_counter_update():
	%ShotCounter.text = str(hamster_ball.shots)

func stage_handler():
	var stages: Array[Node] = %Stages.get_children()
	for i in range(stages.size()):
		if stages[i] is Node2D:
			stages[i].visible = (i == stage)
	hamster_ball.linear_velocity = Vector2.ZERO
	hamster_ball.shots = 0
	hamster_ball.position = starting_pos[stage]
