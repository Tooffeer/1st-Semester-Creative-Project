extends CharacterBody2D

# Maybe only make zombie move when first loaded on screen

# Fix this mess of a code

# Get nodes
@onready var sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox
@onready var gpu_particles_2d = $GPUParticles2D


# Signals
signal healthChanged

# Movement
var direction = -1
var runSpeed = 50

@export var health = 3
@export var damage = 1
@export var x = health

@export var cooldown = 0.7
var cooldownTimer = 0.0
var playerInRange = false
var isAttacking = false
var player

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Change direction when collding with wall
	# Direction is stated outside of process so it isn't reset
	if is_on_wall():
		direction = -direction
	
	# Apply velocity
	velocity.x = direction * runSpeed
	
	
	move_and_slide()
	attack(delta)
	animate()
	
	# Blood effect
	if health != x:
		gpu_particles_2d.emitting = true
		x = health
	
	# Check health
	if health <= 0:
		queue_free()

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

func animate():
	# Face sprite in the direction of movement
	if velocity.x > 0:
		sprite.flip_h = true
	elif velocity.x < 0:
		sprite.flip_h = false
	
	# Play animation
	sprite.play("Run")
