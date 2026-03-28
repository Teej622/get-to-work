extends Node2D

@export var car_scene: PackedScene
@export var spawn_delay = 2.0
@export var car_speed = 250
@export var direction = Vector2.RIGHT
var screen_width = 1280
var timer


func _ready():
	spawn_initial_traffic()
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = spawn_delay
	timer.timeout.connect(_on_timer_timeout)
	timer.start()
	
func spawn_car(x_pos):
	var new_car = car_scene.instantiate()
	add_child(new_car)
	new_car.position = Vector2(x_pos, 0)
	new_car.speed = car_speed
	new_car.direction = direction.rotated(rotation)
	new_car.rotation = rotation
	
func spawn_initial_traffic():
	for i in range(4):
		var random_x = randf_range(0, screen_width)
		spawn_car(random_x)

func _on_timer_timeout():
	spawn_car(-200)
	
func _process(delta: float) -> void:
	if not get_parent().visible:
		timer.stop()
		cleanup_cars()
	else:
			if timer.is_stopped():
				timer.start()
				spawn_initial_traffic()

func cleanup_cars():
	for child in get_children():
		if child is AnimatableBody2D:
			child.queue_free()
