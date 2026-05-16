extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var range_1: CollisionShape2D = $Attack_1/CollisionShape2D
@onready var range_2: CollisionShape2D = $Attack_2/CollisionShape2D
@onready var range_3: CollisionShape2D = $Skill_1/CollisionShape2D
@onready var area_1: Area2D = $Attack_1
@onready var area_2: Area2D = $Attack_2
@onready var area_3: Area2D = $Skill_1
@onready var point: Sprite2D = $point
@export var max_speed: int = 100


const acceleration: int = 5
const friction: int = 10
var is_attack = false
var is_skill = false
var able_skill = true
var is_dodge = false
var attack_time = 0
var skill_stage = false
var is_ok = false
var is_hurt = false
var shape = CircleShape2D.new()

func _ready() -> void:
	range_1.disabled = true
	range_2.disabled = true
	range_3.disabled = true
	area_1.monitoring = false
	area_2.monitoring = false
	area_3.monitoring = false
	PlayerState.connect("is_hurt",_is_hurt)
	shape.radius = 5

func _physics_process(delta: float) -> void:
	point.look_at(PlayerState.target_position)
	if Input.is_action_just_pressed("support_1"):
		PlayerState.do_ATB("support_1")
	if GameDialogueManager.able_attack and !GameDialogueManager.is_dialogue:
		dodge(delta)
		if !is_hurt:
			skill(delta)
			attack(delta)
	if !GameDialogueManager.is_dialogue and GameDialogueManager.able_move and !is_hurt:
		move(delta)
	elif !is_hurt:
		animated_sprite_2d.play("Idle") if PlayerState.player_able_weapon else animated_sprite_2d.play("Idle_no_weapon")



func move(delta):
	var input = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
	).normalized()
	
	
	if input:
		if !is_attack and !is_skill and !is_dodge and !is_hurt:
			animated_sprite_2d.play("Walk") if PlayerState.player_able_weapon else animated_sprite_2d.play("Walk_no_weapon")
			animated_sprite_2d.speed_scale = (velocity/ max_speed).distance_to(Vector2.ZERO) + 0.5
		animated_sprite_2d.flip_h = true if input.x < 0 else false
	else:
		if !is_attack and !is_skill and !is_dodge and !is_hurt:
			animated_sprite_2d.play("Idle") if PlayerState.player_able_weapon else animated_sprite_2d.play("Idle_no_weapon")
			
		
	
	var lerp_weight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * max_speed, lerp_weight)
	if is_skill:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
func attack(delta):
	if Input.is_action_just_pressed("attack_1") and !is_attack:
		animated_sprite_2d.play("Attack_1")
		max_speed = 20
		is_attack = true
		range_1.disabled = false
		area_1.monitoring = true
		
	elif Input.is_action_just_pressed("attack_2") and !is_attack:
		animated_sprite_2d.play("Attack_2")
		max_speed = 500
		is_attack = true
		range_2.disabled = false
		area_2.monitoring = true
		
	#if Input.is_action_just_released("hit_1") or Input.is_action_just_released("hit_2"):
	if !animated_sprite_2d.is_playing():
		max_speed = 100
		is_attack = false
		range_1.disabled = true
		range_2.disabled = true
		area_1.monitoring = false
		area_2.monitoring = false
		

func skill(delta):
	if Input.is_action_just_pressed("skill_1") and !is_skill and PlayerState.now_ATB >= 10:
		PlayerState.now_ATB -= 10
		animated_sprite_2d.play("Skill_1_shang")
		is_skill = true
		skill_stage = true
		is_ok = false
		range_3.disabled = true
		await get_tree().create_timer(1.0).timeout
		self.visible = true
		var has_collision = check_shape_collision(shape, get_global_mouse_position(), 1 << 3)
		if !has_collision:
			self.global_position = get_global_mouse_position()
		animated_sprite_2d.play("Skill_1_xia")
		range_3.disabled = false
		area_3.monitoring = true
		is_ok = true
		
	if !animated_sprite_2d.is_playing() and skill_stage and !is_attack:
		skill_stage = false
		self.visible = false
		
		
	if !animated_sprite_2d.is_playing() and is_ok:
		area_3.monitoring = false
		is_skill = false
		await get_tree().create_timer(0.1).timeout
		range_3.disabled = true

func dodge(delta):
	if Input.is_action_just_pressed("dodge") and able_skill:
		animated_sprite_2d.play("Dodge")
		is_dodge = true
		is_hurt = false
		max_speed = 300
	if !animated_sprite_2d.is_playing():
		max_speed = 100
		is_dodge = false
		able_skill = false
		await get_tree().create_timer(0.5).timeout
		able_skill = true


func position_set(x:float,y:float):
	self.global_position = Vector2(x,y)
	
func _is_hurt():
	if !is_hurt:
		is_hurt = true
		animated_sprite_2d.play("Hurt")
		await get_tree().create_timer(0.3).timeout
		is_hurt = false

func check_shape_collision(shape: Shape2D, position: Vector2, collision_mask: int = 1) -> bool:
	var space_state = get_world_2d().direct_space_state
	# 1. 创建形状查询参数
	var params = PhysicsShapeQueryParameters2D.new()
	params.shape_rid = shape.get_rid()  # 需要先初始化一个Shape2D（如CircleShape2D）
	params.transform = Transform2D(0.0, position)  # 设置形状的位置
	params.collision_mask = collision_mask
	params.exclude = [self]
	# 2. 执行查询
	var results = space_state.intersect_shape(params, 1)  # 最多检测10个结果
	return results.size() > 0
