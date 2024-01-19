extends CharacterBody2D

var health = 3
var damage = 1

@onready var hitbox = $Hitbox

var playerInRange = false
var isAttacking = false
var cooldown = 1.0
var t = 0.0

var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()
	
	attack(delta)
	
	# Check health
	if health <= 0:
		die()

func attack(delta):
	t += delta
	
	if playerInRange and t > cooldown:
		player.playerHealth -= 1
		t = 0.0
		print("Player: ", player.playerHealth)

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		playerInRange = true
		player = body

func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		playerInRange = false

func die():
	queue_free()
