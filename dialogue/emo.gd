extends AnimatedSprite2D


func _ready() -> void:
	GameDialogueManager.connect("emo",emo_change)


func emo_change(which_emo) -> void:
	if which_emo == GameDialogueManager.EmoState.player:
		self.play("player")
	elif which_emo == GameDialogueManager.EmoState.patner_A:
		self.play("patner_A")
	elif which_emo == GameDialogueManager.EmoState.patner_B:
		self.play("patner_B")
	elif which_emo == GameDialogueManager.EmoState.patner_C:
		self.play("patner_C")
	elif which_emo == GameDialogueManager.EmoState.patner_D:
		self.play("patner_D")
	elif which_emo == GameDialogueManager.EmoState.level_1_village_head:
		self.play("level_1_village_head")
	elif which_emo == GameDialogueManager.EmoState.level_1_village_guard:
		self.play("level_1_village_guard")
	elif which_emo == GameDialogueManager.EmoState.spirit:
		self.play("spirit")
