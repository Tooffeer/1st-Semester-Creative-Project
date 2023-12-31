extends CharacterBody2D

# Signals
#signal health_depleted

# Health variables
@export var maxHealth : int = 3
var health : int = 0

# Running variables
@export var runSpeed = 52.0

# Jumping variables
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

func _ready():
	health = maxHealth

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
	
	if Input.is_action_pressed("jump"):
		if canJump:
			velocity.y = jumpVelocity
			canJump = false
	
	# Get player input direction
	var direction = Input.get_axis("left", "right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * runSpeed, delta * 28)
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 20)
	
	# Clamp fall velocity
	if velocity.y > 180:
		velocity.y = 180
	
	move_and_slide()

func getGravity():
	return jumpGravity if velocity.y < 0.0 else fallGravity
