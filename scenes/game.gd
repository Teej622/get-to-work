extends Node2D

@onready var hamster_ball = %HamsterBall
@onready var scoreType = %ScoreType
@export var par = [2, 2, 2, 2]
var stage = 0
var shots
var shot_history = []
var starting_pos = [Vector2(90,80), Vector2(), Vector2(), Vector2()]

func _physics_process(delta: float) -> void:
	%ShotCounter.text = str(hamster_ball.shots)
	shots = %ShotCounter.text.to_int()
	
	%Par.text = "Par: " + str(par[stage])
	

func _on_goal_score() -> void:
	print("score")
	if shots > par[stage] + 3:
		scoreType.text = str(shots) + " over par..."
	elif shots == par[stage] + 3:
		scoreType.text = "Triple Bogey\n(" + str(shots - par[stage]) +" over par)"
	elif shots == par[stage] + 2:
		scoreType.text = "Double Bogey\n(" + str(shots - par[stage]) +" over par)"
	elif shots == par[stage] + 1:
		scoreType.text = "Bogey\n(" + str(shots - par[stage]) +" over par)"
	elif shots == 1:
		scoreType.text = "Hole in One!"
	elif shots == par[stage]:
		scoreType.text = "Par"
	elif shots == par[stage] - 1:
		scoreType.text = "Birdie!\n(" + str(par[stage] - shots) +" under par)"
	elif shots == par[stage] - 2:
		scoreType.text = "Eagle!\n(" + str(par[stage] - shots) +" under par)"
	elif shots == par[stage] - 3:
		scoreType.text = "Albatross!\n(" + str(par[stage] - shots) +" under par)"
	elif shots <= par[stage] - 4:
		scoreType.text = "Holy F$%k!\n(" + str(par[stage] - shots) +" under par)"
	
	print(shots)

	%ScoreScreen.visible = true
	


func _on_next_stage_btn_pressed() -> void:
	stage += 1
	if stage > 4:
		pass
	%ScoreScreen.visible = false
	shot_history.append(shots)
	shot_counter_update()
	stage_handler()
	
func _on_retry_btn_pressed() -> void:
	%ScoreScreen.visible = false
	shots = 0
	shot_counter_update()
	hamster_ball.position = starting_pos[stage]

func shot_counter_update():
	%ShotCounter.text = str(shots)

func stage_handler():
	var stages: Array[Node] = %Stages.get_children()
	for i in range(stages.size()):
		if stages[i] is Node2D:
			stages[i].visible = (i == stage)
