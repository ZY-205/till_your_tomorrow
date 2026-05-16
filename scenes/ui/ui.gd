extends CanvasLayer
@onready var meun: Panel = $Meun
@onready var xuetiao: TextureProgressBar = $xuetiao
@onready var atb: TextureProgressBar = $atb

@export var player: CharacterBody2D


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		meun.visible = !meun.visible
	xuetiao.value = 100 * PlayerState.now_player_health_value/PlayerState.player_health_value
	atb.value = 100 * PlayerState.now_ATB/PlayerState.ATB
	
func _on_save_pressed() -> void:
	var data = Savedata.new()
	data.player_positions = player.global_position
	data.is_facing_right = player.get_child(0).flip_h
	
	var npcs = get_tree().get_nodes_in_group("knight")
	for npc in npcs:
		var npc_scene = PackedScene.new()
		npc_scene.pack(npc)
		data.npc_array.append(npc_scene)
		
	ResourceSaver.save(data,"user://scene_data.tres")

func _on_load_pressed() -> void:
	var data = ResourceLoader.load("user://scene_data.tres") as Savedata
	player.global_position = data.player_positions
	player.get_child(0).flip_h = data.is_facing_right
	
	for npc in get_tree().get_nodes_in_group("knight"):
		npc.queue_free()
		
	for npc in data.npc_array:
		var npc_node = npc.instantiate()
		get_tree().current_scene.add_child(npc_node)
		npc_node.freeze = true
		
	await get_tree().create_timer(0.1).timeout
	for npc in get_tree().get_nodes_in_group("knight"):
		npc.freeze = false


func _on_quit_pressed() -> void:
	get_tree().quit()
