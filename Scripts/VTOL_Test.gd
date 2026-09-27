extends RigidBody3D

@export var max_thrust: float = 30.0
@export var throttle_power: float = 20.0
@export var pitch_speed: float = 5.0
@export var roll_speed: float = 5.0
@export var yaw_speed: float = 3.0

var needs_respawn: bool = false
var spawn_transform: Transform3D

func _ready() -> void:
	spawn_transform = global_transform

func _physics_process(delta: float) -> void:
	var thrust_input = Input.get_action_strength("thrust_up") - Input.get_action_strength("thrust_down")
	var throttle_input = Input.get_action_strength("throttle_forward") - Input.get_action_strength("throttle_back")
	
	var pitch_input = Input.get_action_strength("pitch_down") - Input.get_action_strength("pitch_up")
	var roll_input = Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right")
	var yaw_input = Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right")
	
	var up_force = basis.y * thrust_input * max_thrust
	var forward_force = -basis.z * throttle_input * throttle_power
	
	apply_central_force(up_force + forward_force)
	
	var torque = Vector3.ZERO
	torque.x = pitch_input * pitch_speed
	torque.z = roll_input * roll_speed
	torque.y = yaw_input * yaw_speed
	
	apply_torque(basis * torque)
	
	if Input.is_action_just_pressed("restart"):
		needs_respawn = true

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("ground"):
		needs_respawn = true

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if needs_respawn:
		state.transform = spawn_transform
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		needs_respawn = false
