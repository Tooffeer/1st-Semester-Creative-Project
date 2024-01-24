extends CharacterBody2D

signal attack

# Get nodes
@onready var sprite = $AnimatedSprite2D

# Health
@onready var health = 20

# Movement
var direction = 0
const Speed = 300.0
const chargeSpeed = 600.0

var allowBattle = false
var player

var x = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = chargeSpeed * direction * delta * 10
	
	move_and_slide()
	
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	
	if health <= 0:
		die()

func _on_player_detection_body_entered(body):
	if body.is_in_group("player"):
		player = body
		allowBattle = true
		
		charge()

func charge():
	# Determine if player is on the right or left side of Grendel
	if ((position.x - player.position.x) > 0):
		direction = -1
	elif ((position.x - player.position.x) < 0):
		direction = 1

func die():
	sprite.play("Die")
	await sprite.animation_finished
	queue_free()
