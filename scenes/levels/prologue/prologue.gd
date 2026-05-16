extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

func _ready() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)  # 平滑过渡
	tween.tween_property($CanvasModulate, "color", Color(0.02 ,0.20 ,0.25 ,1.00 ), 4)
	tween.parallel().tween_property($objects/campfire/PointLight2D,"energy",1.0,4)
	await get_tree().create_timer(5).timeout
	var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(load("res://dialogue/conversations/prologue.dialogue"),"start")
