extends Camera2D

var shake_intensity: float = 0.0
var shake_duration: float = 0.0
var time:int = 0

func _process(delta):
	time += 1
	if shake_duration > 0 and time > 3:
		# 随机偏移产生震动效果
		offset = Vector2(
			randf_range(-shake_intensity, shake_intensity),
			randf_range(-shake_intensity, shake_intensity)
		)
		shake_duration -= delta
		time = 0
	else:
		offset = Vector2.ZERO

# 外部调用此方法触发震动
func start_shake(intensity: float, duration: float):
	shake_intensity = intensity
	shake_duration = duration
