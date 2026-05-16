extends CharacterBody2D 
@export var move_speed: float = 75
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack: Area2D = $Attack
@onready var attack_range: CollisionShape2D = $Attack/AttackRange

var live = 5;
var able_attack: bool = false
var is_attack: bool = false
var is_hurt = false
var player
const acceleration: int = 5
const friction: int = 10


func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = 5
	$NavigationAgent2D.target_desired_distance = 5
	_on_path_update_timeout()
	
	animated_sprite_2d.play("Idle")
	attack.monitoring = false
	var player = get_tree().get_first_node_in_group("Player").get_child(2)
	player.connect("attack_data",_on_attack)
	player = get_tree().get_first_node_in_group("Player").get_child(3)
	player.connect("attack_data",_on_attack)
	player = get_tree().get_first_node_in_group("Player").get_child(4)
	player.connect("attack_data",_on_attack)


func _physics_process(delta: float) -> void:
	if $NavigationAgent2D.is_navigation_finished():
		return
	var next_pos = $NavigationAgent2D.get_next_path_position()
	if live < 1:
		animated_sprite_2d.play("Death")
		await get_tree().create_timer(0.5).timeout
		queue_free()
	if !is_attack and !is_hurt:
		player = get_tree().get_first_node_in_group("Player")
		animated_sprite_2d.play("Walk")
		if (global_position - player.global_position).length_squared() <= 120:
			do_attack()
		else:
			var direction = (next_pos - global_position).normalized()
			var lerp_weight = delta * (acceleration if direction else friction)
			velocity = lerp(velocity, direction * move_speed, lerp_weight)
			animated_sprite_2d.flip_h = true if velocity.x < 0 else false
			if animated_sprite_2d.flip_h:
				attack_range.position.x = -13
			else:
				attack_range.position.x = 13
			move_and_slide()
	
	if !animated_sprite_2d.is_playing() and is_attack:
		is_attack = false
		attack.monitoring = false

func _on_attack(attack_data: int,body: Node2D) -> void:
	if body == self and !is_hurt:
		live -= attack_data
		animated_sprite_2d.play("Hurt")
		is_hurt = true
		await get_tree().create_timer(0.35).timeout
		is_hurt = false

func do_attack() -> void:
	animated_sprite_2d.play("Attack")
	is_attack = true
	attack.monitoring = true

func _on_alert_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	animated_sprite_2d.play("Alert")
	await get_tree().create_timer(0.3).timeout
	able_attack = true


func _on_alert_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	animated_sprite_2d.play("Idle")
	able_attack = false


func _on_attack_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	PlayerState.be_hurt(1)


func _on_path_update_timeout():
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		$NavigationAgent2D.target_position = player.global_position
	await get_tree().create_timer(0.5).timeout
	_on_path_update_timeout()
