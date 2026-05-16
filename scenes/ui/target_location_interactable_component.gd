extends InteractableComponent


func _on_body_entered(body: Node2D) -> void:
	interactable_activated.emit()


func _on_body_exited(body: Node2D) -> void:
	interactable_deactivated.emit()
