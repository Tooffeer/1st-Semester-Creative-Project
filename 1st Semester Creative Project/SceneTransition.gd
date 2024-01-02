extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func changeScene(target):
	animation_player.play("Dissolve")
	await animation_player.animation_finished
	get_tree().change
