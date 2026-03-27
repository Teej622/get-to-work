extends RigidBody2D

@onready var power_bar = %PowerBar
@onready var pivot = %PowerPivot

@export var stop_threshold = 50
@export var strength = 10

var shots = 0
var is_charging = false
var power_bar_length = 1.5

const RADIUS = 50

func _ready():
	power_bar.hide()
	
func _physics_process(delta: float) -> void:
	if is_charging:
		var mouse_pos = get_global_mouse_position()
		var dist = global_position.distance_to(mouse_pos) - RADIUS
		power_bar.value = clamp(dist / power_bar_length,0,100)
		pivot.look_at(mouse_pos)
		
	#Changing power bar colour based on intensity
	var fill_stylebox: StyleBoxFlat = power_bar.get_theme_stylebox("fill")
	fill_stylebox.bg_color = Color(1, 1 - (power_bar.value / 100), 0.0, 1.0)
	fill_stylebox.border_color = fill_stylebox.bg_color / 2
	
	#Stop hamster if velocy < stop_threshold
	if linear_velocity.length() < stop_threshold and linear_velocity.length() > 0:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		
	#Dynamic damping
	if linear_velocity.length() > 0:
		if linear_velocity.length() < 100:
			linear_damp = 5.0
		else:
			linear_damp = 2
	

#click release
func _input(event: InputEvent) -> void:
	if is_charging and event.is_action_released("click"):
		shoot()

#click and hovered action
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		is_charging = true
		power_bar.show()
		
func shoot():
	is_charging = false
	power_bar.hide()
	shots += 1
	
	var dir = (global_position - get_global_mouse_position()).normalized()
	var force = power_bar.value * strength
	apply_central_impulse(dir * force)
