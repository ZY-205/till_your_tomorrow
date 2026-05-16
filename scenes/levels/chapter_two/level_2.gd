extends Node2D
@onready var canvas_modulate: CanvasModulate = $CanvasModulate
@onready var cg_by_josn: Node = $CG_by_josn
@onready var on_player: CharacterBody2D = $npc/Player

var tween
var knight_green = preload("res://scenes/characters/knight/knight_green.tscn")
var boss_able = false

func _ready() -> void:
	GameDialogueManager.able_move = false
	PlayerState.player_able_weapon = true
	$CanvasModulate.show()
	cg_by_josn.prepareload("res://cg_josn/level_2.json")
	cg_by_josn.start_cg(1)
	fade_out(5)
	await tween.finished
	dialogue("res://dialogue/conversations/level_2.dialogue","task_one")
	GameDialogueManager.connect("air_wall_removal",air_wall_removal)

func fade_out(duration: float = 2.0, target_color: Color = Color.WHITE):
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 平滑过渡
	tween.tween_property(canvas_modulate, "color", target_color, duration)

func air_wall_removal(which_stage: int) -> void:
	if which_stage == 2:
		fade_out(1,Color.BLACK)
		await tween.finished
		cg_by_josn.start_cg(2)
		fade_out(1,Color.WHITE)
		await tween.finished
		dialogue("res://dialogue/conversations/level_2.dialogue","task_two")
	elif which_stage == 3:
		cg_by_josn.start_cg(3)
	elif which_stage == 4:
		fade_out(1,Color.BLACK)
		await tween.finished
		$object/Sprite2D.hide()
		cg_by_josn.start_cg(4)
		fade_out(1,Color.WHITE)
		await tween.finished
		dialogue("res://dialogue/conversations/level_2.dialogue","task_three")
	elif which_stage == 5:
		fade_out(1,Color.BLACK)
		await tween.finished
		$npc/partner_B.hide()
		fade_out(1,Color.WHITE)
		await tween.finished
		GameDialogueManager.able_move = true
		await get_tree().create_timer(10).timeout
		GameDialogueManager.do_air_wall_removal(6)
	elif which_stage == 6:
		$npc/Player/player_camera.start_shake(1.0,3)
		dialogue("res://dialogue/conversations/level_2.dialogue","task_three_half")
		PlayerState.target_position = Vector2(330,-1570)
		$npc/Player/point.visible = true
		boss_able = true
	elif which_stage == 7:
		cg_by_josn.start_cg(7)
	elif which_stage == 8:
		GameDialogueManager.able_attack = true
		$npc/Player/player_camera/UI/xuetiao.visible = true
		$npc/Player/player_camera/UI/atb.visible = true
		get_tree().get_first_node_in_group("boss").show_xuetiao()
		await get_tree().create_timer(0.5).timeout
		get_tree().get_first_node_in_group("boss").start()
		
func dialogue(which_dialogue:String,which_stage:String):
	var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load(which_dialogue),which_stage)


func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
		if boss_able:
			boss_able = false
			$npc/Player/point.visible = false
			var knight_green_instance = knight_green.instantiate() as Node2D
			knight_green_instance.global_position = Vector2(300,-1390)
			get_parent().add_child(knight_green_instance)
			GameDialogueManager.is_dialogue = true
			fade_out(1,Color.BLACK)
			await tween.finished
			if $npc/Player/AnimatedSprite2D.flip_h:
				$npc/Player/AnimatedSprite2D.flip_h = !$npc/Player/AnimatedSprite2D.flip_h
			cg_by_josn.prepareload("res://cg_josn/level_2.json")
			cg_by_josn.start_cg(6)
			fade_out(1,Color.WHITE)
			await tween.finished
			dialogue("res://dialogue/conversations/level_2.dialogue","task_four")
			
