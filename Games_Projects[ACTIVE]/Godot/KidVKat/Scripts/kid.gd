extends CharacterBody3D

@onready var spring_arm_pivot = $Pivot
@onready var spring_arm = $Pivot/SpringArm3D
@onready var armature = $Armature
@onready var animtree = $AnimationTree
@onready var animplayer = $AnimationPlayer

const SPEED = 5.0
const LERPV = 0.15
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)
		
func _input(event):
	if Input.is_action_just_pressed("lol"):
		animplayer.play("idle")
		
	if Input.is_action_just_pressed("lol1"):
		animplayer.play("run")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta


	
	
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right","forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP,spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x,direction.x * SPEED, LERPV)
		velocity.z = lerp(velocity.z,direction.z * SPEED, LERPV)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERPV)
	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.x = lerp(velocity.x,0.0, LERPV)
		velocity.z = lerp(velocity.z,0.0, LERPV)
	animtree.active = true
	animtree.set("parameters/BlendSpace1D/blend_position",velocity.length() / SPEED)

	move_and_slide()
