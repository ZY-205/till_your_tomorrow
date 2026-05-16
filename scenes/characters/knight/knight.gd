extends AnimatedSprite2D

@onready var partner_animation: AnimatedSprite2D = $"."
@export var who: String

func _ready() -> void:
	if who == 'red':
		partner_animation.play("Idle_knight_red")
	elif who == 'blue':
		partner_animation.play("Idle_knight_blue")
	elif who == 'green':
		partner_animation.play("Idle_knight_green")
	elif who == 'purple':
		partner_animation.play("Idle_knight_purple")

func boom(x: float = 0.0, y: float = 0.0, time: float = 0.0):
	var tween = create_tween()
	var poistion = Vector2(x,y)
	tween.set_ease(Tween.EASE_IN_OUT)  # 添加缓动曲线
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($"../knight_purple/Sprite2D", "scale",poistion, time)
	
