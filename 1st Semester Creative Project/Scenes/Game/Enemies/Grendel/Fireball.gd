extends CharacterBody2D

@export var damage = 1
@export var speed = 150
var target

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	velocity.x = speed
	#velocity = velocity.rotated(rotation)
	
	
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		body.playerHealth -= damage
		queue_free()

