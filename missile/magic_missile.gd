extends Node3D

var type_id = 4

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(_body: Node) -> void:
	queue_free()

func _on_body_exited(_body: Node) -> void:
	queue_free()
