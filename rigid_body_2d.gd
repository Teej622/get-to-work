extends RigidBody2D

@onready var power_bar = $PowerBar
var is_charging = false

func _ready():
	power_bar.hide()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("click"):
		print("clicked")
