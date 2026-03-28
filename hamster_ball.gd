extends RigidBody2D

@onready var power_bar = %PowerBar
@onready var pivot = %PowerPivot
@onready var arrow = %Arrow
@onready var hamster_anim = %HamsterBallAnim

@export var stop_threshold = 50
@export var strength = 10

var shots = 0
var is_charging = false
var power_bar_length = 1.5
var teleport_to
signal siren

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
		
	#Stop hamster if velocity < stop_threshold
	if linear_velocity.length() < stop_threshold and linear_velocity.length() > 0:
		linear_velocity = Vector2.ZERO
		angular_velocity = 0
		hamster_anim.play("Idle")
		
	#Dynamic damping
	if linear_velocity.length() > 0:
		if linear_velocity.length() < 100:
			linear_damp = 5.0
		else:
			linear_damp = 2
	else:
		hamster_anim.play("Idle")

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
		$Woosh.pitch_scale = randf_range(0.8, 1.2)
		$Woosh.play()
		shots += 1
		hamster_anim.play("Roll")
		if dir.x < 0:
			hamster_anim.flip_h = true
		else:
			hamster_anim.flip_h = false

func hide_ui():
	power_bar.hide()
	arrow.hide()

func show_ui():
	power_bar.show()
	arrow.show()

func _on_game_reset_physics() -> void:
	mass = 1.5
	physics_material_override.friction = 1
	physics_material_override.bounce = 0.65
	strength = 40
	
func teleport(pos: Vector2) -> void:
	teleport_to = pos

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if teleport_to != Vector2.INF:
		var t = state.transform
		t.origin = teleport_to
		state.transform = t
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		teleport_to = Vector2.INF
		
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Object") and (body.is_class("StaticBody2D") or body.is_class("AnimatableBody2D")):
		var sprite = body.get_node_or_null("CarSprite")
		if sprite and sprite.animation == "POLICE":
			$Siren.play()
		var rand_shout = randi() % 10
		if rand_shout == 0:
			$Shout1.play()
		if rand_shout == 1:
			$Shout2.play()
	if body.is_in_group("Object"):
		if linear_velocity.length() >= 500:
			play_sound()

	
func play_sound():
	var rand_audio = randi() % 2
	if rand_audio == 0:
		$Boing.play()
	elif rand_audio == 1:
		$Boioing.play()
