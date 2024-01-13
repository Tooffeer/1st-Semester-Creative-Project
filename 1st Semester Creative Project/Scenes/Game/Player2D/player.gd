extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

# Health variables
var playerHealth : float = 0
var MAXplayerHealth : float = 3

# Running variables
@export var runSpeed = 120.0

# Jumping variables
@export var jumpHeight : float = 55
@export var jumpTimeToPeak : float = 0.295
@export var jumpTimeToDescent : float = 0.22
@export var coyoteTime : float = 0.16
@export var wallJumpPushback : float = 275
@export var wallJumpGravity : float = 90

@onready var jumpVelocity : float = -((2.0 * jumpHeight) / jumpTimeToPeak)
@onready var jumpGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0))
@onready var fallGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToDescent, 2.0))

var canJump : bool = true
var coyoteTimer = 0.0
var isWallSliding : bool

# Animation
var states = ["Idle", "Run", "Jump", "Fall", "Wallslide"]
var currentState = states[0]

func _ready():
	playerHealth = MAXplayerHealth

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get player input direction
	var direction = Input.get_axis("left", "right")
	
	# Movement functions
	jump(delta, direction)
	wallSlide(delta, direction)
	
	# Get horizontal velocity
	if direction:
		velocity.x = move_toward(velocity.x, direction * runSpeed, delta * 600)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * 600)
	
	# Clamp falling velocity
	if velocity.y > 300:
		velocity.y = 300
	
	move_and_slide()
	
	# Health system
	if playerHealth <= 0:
		die()
	
	stateMachine(direction)

func jump(delta, direction):
	if not is_on_floor():
		# Apply gravity when in air
		velocity.y += getGravity() * delta
		
		# Starts the coyote timer
		coyoteTimer += delta
		# Player can still jump until the coyote timer goes over the time limit
		if coyoteTimer > coyoteTime:
			canJump = false
	else:
		# Since player is grounded the coyoteTimer is reset and allows jump
		coyoteTimer = 0.0
		canJump = true
	
	# When player tries to jump
	if Input.is_action_just_pressed("jump") and is_on_wall():
		# Jumping off of a wall
		if direction != 0:
			velocity.y = jumpVelocity
			if direction < 0:
				velocity.x = wallJumpPushback
			if direction > 0:
				velocity.x = -wallJumpPushback
	if Input.is_action_pressed("jump"):
		# Jumping from ground
		if canJump:
			velocity.y = jumpVelocity
			canJump = false

func wallSlide(delta, direction):
	if is_on_wall() and !is_on_floor():
		if direction != 0:
			isWallSliding = true
	else:
		isWallSliding = false
	
	if isWallSliding:
		velocity.y += wallJumpGravity * delta
		velocity.y = min(velocity.y, wallJumpGravity)

func getGravity():
	return jumpGravity if velocity.y < 0.0 else fallGravity

func stateMachine(direction):
	# Face sprite in the direction of movement
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true
	
	# Check player states
	if isWallSliding == true:
		# Is wallslidng
		currentState = states[4]
		# Flip sprite to correctly face wall
		if direction < 0:
			sprite.flip_h = false
		if direction > 0:
			sprite.flip_h = true
	elif velocity == Vector2.ZERO:
		# Is standing still
		currentState = states[0]
	elif velocity.y < 0:
		# Is rising
		currentState = states[2]
	elif velocity.y > 0:
		# Is falling
		currentState = states[3]
	elif velocity.x != 0:
		# Is moving on ground
		currentState = states[1]
	
	# Match state with animation
	for state in states:
		if currentState == state:
			sprite.play(state)

func die():
	# Removes the player scene
	pass
