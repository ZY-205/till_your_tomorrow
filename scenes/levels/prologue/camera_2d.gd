extends Camera2D
@onready var canvas_modulate: CanvasModulate = $"../../../CanvasModulate"
@onready var point_light_2d: PointLight2D = $"../../../objects/campfire/PointLight2D"

# 目标缩放值（小于1表示拉近，大于1表示拉远）
var target_zoom := Vector2(0.3,0.3)  # 示例：拉近到50%
var zoom_duration := 10  # 持续时间（秒）

func _physics_process(delta: float) -> void:
	if GameDialogueManager.able_do_something:
		start_zoom()
		fade_out(10)
		GameDialogueManager.able_do_something = false
		await get_tree().create_timer(10).timeout
		get_tree().change_scene_to_file("res://scenes/levels/chapter_one/level_1.tscn")

func start_zoom():
	# 创建 Tween 动画
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 缓动类型：平滑出入
	tween.set_trans(Tween.TRANS_QUAD)  # 过渡曲线：二次方
	
	# 从当前缩放值过渡到目标值
	tween.tween_property(self,"zoom",target_zoom,zoom_duration)
	tween.tween_callback(_on_zoom_finished)

func _on_zoom_finished():
	print("摄像机拉近完成！")

func fade_out(duration: float = 2.0, target_color: Color = Color(0, 0, 0, 1)):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 平滑过渡
	tween.tween_property(canvas_modulate, "color", target_color, duration)
	tween.parallel().tween_property(point_light_2d,"energy",0.0,duration)
