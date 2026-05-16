extends CharacterBody2D
@export var move_speed: float = 80
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var live = 100.0
var now_live = 100.0
var sword_wave = preload("res://scenes/characters/knight/sword_wave.tscn")
var skeleton = preload("res://scenes/characters/npc/skeleton.tscn")
var is_hurt = false
var is_attack_1 = false
var is_attack_2 = false
var is_attack_3 = false
var is_attack_4 = false
var is_cg = true
var able_attack = true
const acceleration: int = 5
const friction: int = 10

func _ready() -> void:
	add_to_group("boss")
	#导航启动
	$NavigationAgent2D.path_desired_distance = 5
	$NavigationAgent2D.target_desired_distance = 5
	_on_path_update_timeout()
	#受伤节点绑定
	
	var player = get_tree().get_first_node_in_group("Player").get_child(2)
	player.connect("attack_data",_on_attack)
	player = get_tree().get_first_node_in_group("Player").get_child(3)
	player.connect("attack_data",_on_attack)
	player = get_tree().get_first_node_in_group("Player").get_child(4)
	player.connect("attack_data",_on_attack)
	PlayerState.connect("support_1",on_support_1)
	#攻击节点清空
	$Attack_1.monitoring = false
	$Attack_2.monitoring = false
	
func _physics_process(delta: float) -> void:
	if !is_cg:
		if $NavigationAgent2D.is_navigation_finished():
			return
		var next_pos = $NavigationAgent2D.get_next_path_position()
		if now_live < 1:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)  # 添加缓动曲线
			tween.set_trans(Tween.TRANS_SINE)
			tween.tween_property($boom, "scale",Vector2(13,13), 2)
			await tween.finished
			queue_free()
		
		#血条控制
		$CanvasLayer/xuetiao.value = 9 + (now_live/live) * 81
		#攻击逻辑
		if able_attack and !is_attack_1 and !is_attack_2 and !is_attack_3 and !is_attack_4:
			able_attack = false
			var temp = randi_range(1,4)
			if temp == 1:
				attack_1()
			elif temp == 2:
				attack_2()
			elif temp == 3:
				attack_3()
			elif temp == 4:
				attack_4()
			await get_tree().create_timer(8).timeout
			able_attack = true

		if !is_hurt:
			var direction = (next_pos - global_position).normalized()
			var lerp_weight = delta * (acceleration if direction else friction)
			velocity = lerp(velocity, direction * move_speed, lerp_weight)
			animated_sprite_2d.flip_h = true if velocity.x < 0 else false
			if !is_attack_1 and !is_attack_2 and !is_attack_3 and !is_attack_4:
				animated_sprite_2d.play("Walk")
			if animated_sprite_2d.flip_h:
				$Attack_1/Attack_1_Range.position.x = -19
			else:
				$Attack_1/Attack_1_Range.position.x = 19
			move_and_slide()

func _on_attack(attack_data: int,body: Node2D) -> void:
	if body == self and !is_hurt:
		now_live -= attack_data
		$Attack_1.monitoring = false
		$Attack_2.monitoring = false
		if !is_attack_1 and !is_attack_2 and !is_attack_3 and !is_attack_4:
			animated_sprite_2d.play("Hurt")
		is_hurt = true
		await get_tree().create_timer(0.35).timeout
		is_hurt = false

func attack_1():
	is_attack_1 = true
	move_speed = 0
	animated_sprite_2d.play("Attack_1")
	var player = get_tree().get_first_node_in_group("Player")
	await get_tree().create_timer(1).timeout
	$Attack_1/Instruction.global_position = player.global_position
	$Attack_1/Instruction.visible = true
	await get_tree().create_timer(1).timeout
	$Attack_1/Instruction.visible = false
	self.global_position = $Attack_1/Instruction.global_position
	$Attack_1.monitoring = true
	await get_tree().create_timer(0.5).timeout
	$Attack_1.monitoring = false
	move_speed = 80
	is_attack_1 = false

func attack_2():
	is_attack_2 = true
	animated_sprite_2d.play("Attack_2")
	move_speed = 120
	for i in range(1,5):
		$Attack_2.monitoring = true
		await get_tree().create_timer(0.8).timeout
		$Attack_2.monitoring = false
	$Attack_2.monitoring = false
	is_attack_2 = false
	
func attack_3():
	is_attack_3 = true
	move_speed = 40
	animated_sprite_2d.play("Attack_3")
	for i in range(1,10):
		await get_tree().create_timer(0.6).timeout
		var sword_wave_instance = sword_wave.instantiate() as Node2D
		sword_wave_instance.global_position = global_position
		get_parent().add_child(sword_wave_instance)
	move_speed = 80
	is_attack_3 = false
	
func attack_4():
	is_attack_4 = true
	move_speed = 0
	animated_sprite_2d.play("Attack_4")
	for i in range(1,5):
		await get_tree().create_timer(0.6).timeout
		var skeleton_instance = skeleton.instantiate() as Node2D
		skeleton_instance.global_position = global_position + Vector2(
			randf_range(-20,20),
			randf_range(-20,20)
		)
		get_parent().add_child(skeleton_instance)
	move_speed = 80
	is_attack_4 = false

func _on_path_update_timeout():
	# 获取玩家位置并设置目标
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		$NavigationAgent2D.target_position = player.global_position
	await get_tree().create_timer(0.5).timeout
	_on_path_update_timeout()
	
func on_support_1():
	$vine.visible = true
	move_speed = 0
	is_attack_1 = true
	await get_tree().create_timer(3).timeout
	$vine.visible = false
	move_speed = 80
	is_attack_1 = false
	
func _on_attack_1_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	PlayerState.be_hurt(10)


func _on_attack_2_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	PlayerState.be_hurt(5)

func start():
	is_cg = false

func stop():
	is_cg = true

func show_xuetiao():
	$CanvasLayer/xuetiao.visible = true
