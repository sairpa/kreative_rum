extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var SPRINT_VELOCITY = 1.0

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		SPRINT_VELOCITY = 4.0
	if Input.is_action_just_released("sprint") and is_on_floor():
		SPRINT_VELOCITY = 1.0
	
	if direction:
		velocity.x = direction.x * SPEED * SPRINT_VELOCITY
		velocity.z = direction.z * SPEED * SPRINT_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * SPRINT_VELOCITY)
		velocity.z = move_toward(velocity.z, 0, SPEED * SPRINT_VELOCITY)

	move_and_slide()
