extends Area3D

const rotSpeed = 4.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_y(deg_to_rad(rotSpeed))


func _on_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		queue_free()
		body.queue_free()
