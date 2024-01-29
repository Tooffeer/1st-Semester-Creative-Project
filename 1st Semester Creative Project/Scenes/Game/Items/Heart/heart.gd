extends CharacterBody2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

const healingAmount = 2
var x = false 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and x == false:
		x = true
		body.playerHealth += healingAmount
		$AnimatedSprite2D.hide()
		audio_stream_player_2d.play()
		await audio_stream_player_2d.finished
		queue_free()
