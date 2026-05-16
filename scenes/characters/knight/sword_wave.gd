extends Sprite2D

var speed = 5

func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	look_at(player.global_position)
	await get_tree().create_timer(6).timeout
	self.queue_free()

func _physics_process(delta: float) -> void:
	self.position.x += cos(deg_to_rad(get_rotation()*60))*speed
	self.position.y += sin(deg_to_rad(get_rotation()*60))*speed

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	PlayerState.be_hurt(1)
