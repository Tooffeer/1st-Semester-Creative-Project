extends CharacterBody2D

# Get nodes
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var gpu_particles_2d = $GPUParticles2D
@onready var ray_cast_2d = $RayCast2D


# Signals
signal healthChanged

@export var health = 3
@export var damage = 1
@export var x = health

@export var cooldown = 0.7
var cooldownTimer = 0.0
var playerInRange = false
var isAttacking = false
var player


var runSpeed = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	var direction = -1
	if ray_cast_2d.is_colliding():
		if direction < 0:
			direction = 1
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * runSpeed, delta * 600)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 600)
	
	move_and_slide()
	
	attack(delta)
	animate(direction)
	
	if health != x:
		gpu_particles_2d.emitting = true
		x = health
	
	# Check health
	if health <= 0:
		die()

func attack(delta):
	cooldownTimer  += delta
	
	if playerInRange and cooldownTimer > cooldown:
		player.playerHealth -= damage
		cooldownTimer = 0.0
		print("Player: ", player.playerHealth)

func _on_hitbox_body_entered(body):
	if body.is_in_group("player"):
		playerInRange = true
		player = body

func _on_hitbox_body_exited(body):
	if body.is_in_group("player"):
		playerInRange = false

func animate(direction):
	# Face sprite in the direction of movement
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	# Play animation
	sprite.play("Run")

func die():
	queue_free()
