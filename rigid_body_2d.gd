extends RigidBody2D

@onready var power_bar = %PowerBar
@onready var pivot = %PowerPivot

@onready var arrow = %Arrow

@export var stop_threshold = 50
@export var strength = 10

var shots = 0
var is_charging = false
var power_bar_length = 1.5

const RADIUS = 50

func _ready():
	hide_ui()
	
func _physics_process(delta: float) -> void:
	if is_charging:
		var mouse_pos = get_global_mouse_position()
		var dist = global_position.distance_to(mouse_pos) - RADIUS
		power_bar.value = clamp(dist / power_bar_length,0,100)
		pivot.look_at(mouse_pos)
		
	#Changing power bar and arrow colour based on intensity
	var power_fill: StyleBoxFlat = power_bar.get_theme_stylebox("fill")
	power_fill.bg_color = Color(1, 1 - (power_bar.value / 100), 0.0, 1.0)
	power_fill.border_color = power_fill.bg_color / 2
	
	var arrow_fill: Sprite2D = arrow.get_child(0)
	arrow_fill.modulate = Color(power_fill.bg_color)
		
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
		show_ui()
		
func shoot():
	is_charging = false
	hide_ui()
	
	var dir = (global_position - get_global_mouse_position()).normalized()
	var force = power_bar.value * strength
	apply_central_impulse(dir * force)
	#only increase score if the hamster actually moved
	if force > 0:
		shots += 1
	
func hide_ui():
	power_bar.hide()
	arrow.hide()
	
func show_ui():
	power_bar.show()
	arrow.show()
	
