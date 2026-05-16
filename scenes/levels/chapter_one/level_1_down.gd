extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
var is_blink = true

func _ready() -> void:
	$CG_by_josn.prepareload("res://cg_josn/level_1_down.json")
	GameDialogueManager.connect("air_wall_removal",air_wall_removal)
	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://dialogue/conversations/level_1.dialogue"),"task_three")
	start_blink(7,100)
	$CG_by_josn.start_cg(4)


func start_blink(duration: float = 0.5,c: int = 1) -> void:
	var target_color = Color(0.1, 0.1, 0.1)  # 目标暗色（可根据需要调整）
	# 分段动画：变暗 -> 恢复
	for i in range(c):
		if is_blink:
			var tween = create_tween()
			tween.tween_property($CanvasModulate, "color", target_color, duration/2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property($CanvasModulate, "color", Color(0.3,0.3,0.3,1), duration/2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			await tween.finished
			
func air_wall_removal(which_stage: int) -> void:
	if which_stage == 4:
		is_blink = false
		var tween = create_tween()
		tween.tween_property($CanvasModulate, "color", Color.BLACK, 4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		$Sprite2D.visible = true
		$CG_by_josn.start_cg(5)
		tween = create_tween()
		tween.tween_property($CanvasModulate, "color", Color.WHITE, 5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		$partner_D.play("Idle_D_weapon")
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(load("res://dialogue/conversations/level_1.dialogue"),"task_four")
	elif which_stage == 5:
		get_tree().change_scene_to_file("res://scenes/levels/chapter_two/level_2.tscn")
		
