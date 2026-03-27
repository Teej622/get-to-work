extends RigidBody2D

@onready var power_bar = $PowerBar
var is_charging = false

func _ready():
	power_bar.hide()
	
func _physics_process(delta: float) -> void:
	if is_charging:
		var mouse_pos = get_global_mouse_position()
		var dist = global_position.distance_to(mouse_pos)
		power_bar.value = clamp(dist,power_bar.step,100)
		#power_bar.look_at(mouse_pos)

#release
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
	
	var dir = (global_position - get_global_mouse_position()).normalized()
	var force = power_bar.value * 10
	apply_central_impulse(dir * force)
