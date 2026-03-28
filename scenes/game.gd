extends Node2D

@onready var hamster_ball = %HamsterBall
@onready var scoreType = %ScoreType
@onready var background = %Background
@export var par = [4, 3, 4, 4]
var stage = 0
var shot_history = []
var starting_pos = [Vector2(90,80), Vector2(90,80), Vector2(90,80), Vector2(90,80)]
var just_reset = false

func _ready():
	stage_handler()

func _physics_process(delta: float) -> void:
	
	%ShotCounter.text = str(hamster_ball.shots)
	%Par.text = "Par: " + str(par[stage])
	
	if Input.is_action_pressed("retry") and %ScoreScreen.visible == false:
		stage_handler()
	
	# skip bounds check this frame
	if just_reset:
		just_reset = false
		return 
	
	#in case hamster gets forced out of bounds by car
	if hamster_ball.global_position.x <= -55 or hamster_ball.global_position.x >= 1165 or hamster_ball.global_position.y <= -55 or hamster_ball.global_position.y >= 700:
		hamster_ball.global_position = starting_pos[stage]
		hamster_ball.linear_velocity = Vector2.ZERO
		
	

func _on_goal_score() -> void:
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
	
	%ScoreScreen.visible = true
	hamster_ball.linear_velocity = Vector2.ZERO
	hamster_ball.get_node("/root/Game/HamsterBall/HamsterBall").visible = false
	


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
	bg_modulate()
	hamster_ball.freeze = true
	hamster_ball.linear_velocity = Vector2.ZERO
	hamster_ball.shots = 0
	hamster_ball.global_position = starting_pos[stage]
	just_reset = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	hamster_ball.freeze = false
	hamster_ball.get_node("/root/Game/HamsterBall/HamsterBall").visible = true
	
func bg_modulate():
	if stage == 0:
		background.modulate = Color(1.0, 0.894, 0.876, 1.0)
	if stage == 1:
		background.modulate = Color(0.094, 0.079, 0.156, 1.0)
	if stage == 2:
		background.modulate = Color(0.848, 0.978, 0.829, 1.0)
	if stage == 3:
		background.modulate = Color(0.968, 0.917, 1.0, 1.0)
