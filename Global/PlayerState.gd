extends Node

var player_able_weapon = false
var player_health_value = 20
var now_player_health_value = 20
var ATB = 20
var now_ATB = 0
var target_position: Vector2 = Vector2(0,0)
var is_hurt_now = false

signal is_hurt
signal support_1
signal support_2
signal support_3

func be_hurt(num:int):
	if !is_hurt_now:
		is_hurt_now = true
		is_hurt.emit()
		now_player_health_value = now_player_health_value - num
		await get_tree().create_timer(0.3).timeout
		is_hurt_now = false
		
func do_ATB(which:String):
	if now_ATB > 20:
		now_ATB = 20
	if now_ATB >= 10:
		now_ATB -= 10
		emit_signal(which)
	
	
