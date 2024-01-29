extends CharacterBody2D

@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var x = false
func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and x == false:
		x = true
		body.coins += 1
		audio_stream_player_2d.play()
		$AnimatedSprite2D.hide()
		await audio_stream_player_2d.finished
		queue_free()
