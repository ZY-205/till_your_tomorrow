extends Node
var is_monster_generation = false
var is_dialogue = false
var able_attack = false
var able_move = true
enum EmoState {player, patner_A, patner_B, patner_C, patner_D ,level_1_village_head ,level_1_village_guard,spirit}
var able_do_something = false

signal emo(which_emo: EmoState)
signal air_wall_removal(which_stage: int)

func emo_change(which_emo: EmoState) -> void:
	emo.emit(which_emo)

func do_air_wall_removal(which_stage: int) -> void:
	air_wall_removal.emit(which_stage)
	
