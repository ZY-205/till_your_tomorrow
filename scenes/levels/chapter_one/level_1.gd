extends Node2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var stage_1: CollisionShape2D = $air_wall/stage/stage_1/stage_1
@onready var target_location: Node2D = $target_location
@onready var point: Sprite2D = $Player/point
@onready var partner: Node2D = $npc/partner
@onready var stage_2: Area2D = $CG/stage_2


@export var cameras: Array[Camera2D] = []  # 在编辑器拖拽绑定相机节点

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
var current_camera_index := 0
var tween: Tween

func _ready() -> void:
	$CG_by_josn.prepareload("res://cg_josn/level_1.json") 
	fade_out(5)
	GameDialogueManager.connect("air_wall_removal",air_wall_removal)
	cameras[current_camera_index].make_current()
	

func fade_out(duration: float = 2.0, target_color: Color = Color.WHITE):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 平滑过渡
	tween.tween_property(canvas_modulate, "color", target_color, duration)

func air_wall_removal(which_stage: int) -> void:
	if which_stage == 1:
		stage_1.disabled = true
		PlayerState.target_position = target_location.global_position
		point.visible = true
	elif which_stage == 2:
		await get_tree().create_timer(3).timeout
		partner.visible = true
		stage_2.visible = true
		stage_2.monitoring = true
		cameras[current_camera_index].start_shake(2.5,2)
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(load("res://dialogue/conversations/level_1.dialogue"),"task_one_2")
		target_location.global_position = Vector2(500,0)
		PlayerState.target_position = target_location.global_position
	elif which_stage == 3:
		await $CG_by_josn.start_cg(3)
		get_tree().change_scene_to_file("res://scenes/levels/chapter_one/level_1_down.tscn")
		
		
func switch_camera():
	# 获取新旧相机
	var old_camera = cameras[current_camera_index]
	current_camera_index = (current_camera_index + 1) % cameras.size()
	var new_camera = cameras[current_camera_index]
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 添加缓动曲线
	tween.set_trans(Tween.TRANS_SINE)
	
	# 并行动画：位置 + 旋转
	tween.tween_property(old_camera, "global_position", new_camera.global_position, 10)
	tween.parallel().tween_property(old_camera, "rotation", new_camera.rotation, 10)  # 假设目标旋转为0
	
	# 延迟禁用旧相机
	await get_tree().create_timer(10).timeout
	old_camera.enabled = false
	new_camera.make_current()


func _on_stage_2_body_entered(body: Node2D) -> void:
	GameDialogueManager.is_dialogue = true
	switch_camera()
	await get_tree().create_timer(10).timeout
	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://dialogue/conversations/level_1.dialogue"),"task_two")
