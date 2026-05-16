extends AnimatedSprite2D

@onready var partner_animation: AnimatedSprite2D = $"."
@export var who: String
var tween

func _ready() -> void:
	if who == 'A':
		partner_animation.play("Idle_A")
	elif who == 'B':
		partner_animation.play("Idle_B")
	elif who == 'C':
		partner_animation.play("Idle_C")
	elif who == 'D':
		partner_animation.play("Idle_D_weapon")

func move(x: float = 0.0, y: float = 0.0, time: float = 0.0):
	tween = create_tween()
	var poistion = Vector2(x,y)
	tween.set_ease(Tween.EASE_IN_OUT)  # 添加缓动曲线
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position",self.global_position + poistion, time)

func stopmove():
	tween.pause()

func position_set(x:float,y:float):
	self.global_position = Vector2(x,y)
	
func flip_material_H():
	self.flip_h = !self.flip_h
