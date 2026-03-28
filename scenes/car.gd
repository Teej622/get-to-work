extends StaticBody2D

func _physics_process(delta: float) -> void:
	if is_visible_in_tree():
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = false
				
	else:
		for child in get_children():
			if child is CollisionShape2D:
				child.disabled = true
