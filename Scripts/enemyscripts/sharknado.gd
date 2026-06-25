extends Enemy

class_name SharkNado
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const STOP_DISTANCE = 50.0

#initializing variables
func _ready() -> void:
	
	stats.curr_speed = stats.max_speed


func _physics_process(delta: float) -> void:
	var distance = global_position.distance_to(player.global_position)
	if distance < STOP_DISTANCE:
		velocity = Vector2.ZERO
	else:
		navigation_agent_2d.target_position = player.global_position
		var next_pos = navigation_agent_2d.get_next_path_position()
		var direction = global_position.direction_to(next_pos)
		velocity = direction * stats.curr_speed
	update_animation()
	move_and_slide()


func update_animation() -> void:
	if not player:
		return

	if player.global_position.x < global_position.x:
		if animated_sprite.animation != "walk_left":
			animated_sprite.play("walk_left")
	else:
		if animated_sprite.animation != "walk_right":
			animated_sprite.play("walk_right")
