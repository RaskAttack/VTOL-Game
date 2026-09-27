extends XRController3D

# Make sure this path correctly points to the AnimationPlayer inside your .glb node
@onready var anim_player: AnimationPlayer = $Hand/AnimationPlayer
var is_played_grip = false
var is_played_idle = false

# Replace these with the actual names from your AnimationPlayer
var idle_anim: String = "ArmatureAction"
var grip_anim: String = "ArmatureAction_001"

func _process(delta: float) -> void:
	# get_float reads the analog value from the OpenXR action map (0.0 to 1.0)
	var grip_value = get_float("grip")
	
	# If the trigger/grip is pulled past 10%, play the closed animation
	if grip_value > 0.1:
		anim_player.play(grip_anim)
	#	is_played_grip = true
	else:
		pass
