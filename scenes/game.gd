extends Node2D

@onready var shot_count_label = %ShotCounter.text
@onready var hamster_ball = get_node("/root/Game/HamsterBall")
@onready var scoreType = %ScoreType
@export var par = [2]
var stage = 0
var shots

func _physics_process(delta: float) -> void:
	%ShotCounter.text = str(hamster_ball.shots)
	shots = %ShotCounter.text.to_int()

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

	get_tree().paused = true
	%ScoreScreen.visible = true
	
