extends Node2D

signal score

func _on_area_2d_body_entered(body: Node2D) -> void:
	score.emit()
