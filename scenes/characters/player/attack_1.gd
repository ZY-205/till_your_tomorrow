extends Area2D

signal attack_data(attack_data: int,body: Node2D)

@onready var player_camera: Camera2D = $"../player_camera"
@export var hit_damage : int = 2

func screen_shake(intensity: float = 2.0, duration: float = 0.1):
	player_camera.start_shake(intensity, duration)
	
func hit_stop(pause_frames: int = 3):
	Engine.time_scale = 0.75
	await get_tree().create_timer(pause_frames * 0.016).timeout
	Engine.time_scale = 1


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	PlayerState.now_ATB += 1
	attack_data.emit(hit_damage,body)
	screen_shake()
	hit_stop()
