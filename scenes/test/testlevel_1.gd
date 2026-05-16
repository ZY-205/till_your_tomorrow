extends Node2D
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $Player

var able_monster_generation = true
var yue = preload("res://scenes/characters/npc/skeleton.tscn")

func _ready() -> void:
	PlayerState.player_able_weapon = true
	GameDialogueManager.able_attack = true

func _physics_process(delta: float) -> void:
		if GameDialogueManager.is_monster_generation and able_monster_generation:
			var yue_instance = yue.instantiate() as Node2D
			var p: Vector2 
			p.x = player.global_position.x + randi_range(-300,300)
			p.y = player.global_position.y + randi_range(-300,300)
			yue_instance.global_position = p
			get_node("testnpc").add_child(yue_instance)
			able_monster_generation = false
			await get_tree().create_timer(3.0).timeout
			able_monster_generation = true
