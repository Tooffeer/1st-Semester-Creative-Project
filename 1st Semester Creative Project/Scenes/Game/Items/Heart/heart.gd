extends CharacterBody2D

const healingAmount = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth += healingAmount
		print(body.playerHealth)
		queue_free()