extends CharacterBody2D

@export var runSpeed = 52.0

# Jumping
@export var jumpHeight : float
@export var jumpTimeToPeak : float
@export var jumpTimeToDescent : float

@onready var jumpVelocity : float = -((2.0 * jumpHeight) / jumpTimeToPeak)
@onready var jumpGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToPeak, 2.0))
@onready var fallGravity : float = -((-2.0 * jumpHeight) / pow(jumpTimeToDescent, 2.0))

# Coyote Jump variables
var coyoteTime = 0.16
var canJump : bool = true
var coyoteTimer = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += getGravity() * delta
		coyoteTimer += delta
		if coyoteTimer > coyoteTime:
			canJump = false
	else:
		coyoteTimer = 0.0
		canJump = true
	
	if Input.is_action_just_pressed("jump"):
		if canJump:
			velocity.y = jumpVelocity
	
	# Get player input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * runSpeed, delta * 12)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 16)
	
	# Clamp fall velocity
	if velocity.y > 180:
		velocity.y = 180
	
	move_and_slide()

func getGravity():
	return jumpGravity if velocity.y < 0.0 else fallGravity
