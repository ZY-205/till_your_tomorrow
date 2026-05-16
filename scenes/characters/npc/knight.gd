extends CharacterBody2D 
@onready var player: CharacterBody2D = $"../Player"
@export var move_speed: float = 50
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var live = 5;
const acceleration: int = 5
const friction: int = 10


func _ready() -> void:
	animated_sprite_2d.play("walk")
	var player = get_node("/root/Node2D/Player").get_child(2)
	player.connect("attack_data",_on_attack)
	player = get_node("/root/Node2D/Player").get_child(3)
	player.connect("attack_data",_on_attack)
	player = get_node("/root/Node2D/Player").get_child(4)
	player.connect("attack_data",_on_attack)

func _physics_process(delta: float) -> void:
	if live < 1:
		queue_free()
	var player = get_node("/root/Node2D/Player")
	var direction = (player.global_position - global_position).normalized()
	var lerp_weight = delta * (acceleration if direction else friction)
	velocity = lerp(velocity, direction * move_speed, lerp_weight)
	animated_sprite_2d.flip_h = true if velocity.x < 0 else false
	move_and_slide()
	

func _on_attack(attack_data: int,body: Node2D) -> void:
	if body == self:
		live -= attack_data
