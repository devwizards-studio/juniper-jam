extends CharacterBody2D
class_name Player

@export var time_scaler: TimeScaler

@export var stats : CombatStats
@export var sprite : AnimatedSprite2D
@export var max_hp : int
var curr_hp : int 
@export var atk_dmg : int

var in_minigame : bool = false
var acceleration : int = 25
var friction : int =  5

@export var path2D : Path2D
@export var pathFollow : PathFollow2D
@export var wave_enemy_position : Marker2D

func _ready() -> void:
	time_scaler.time_scale = 1.0
	curr_hp = max_hp

func _physics_process(delta: float) -> void:
	movement(delta)

func movement(delta: float):
	if in_minigame:
		return
	var input = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	).normalized()
	
	if input.length() > 0:
		if abs(input.x) > abs(input.y):
			if input.x > 0:
				sprite.play("walk_right")
			else:
				sprite.play("walk_left")
		else:
			if input.y > 0:
				sprite.play("walk_down")
			else:
				sprite.play("walk_up")
	else:
		sprite.play("idle")
	
	var lerp_weight = delta * (acceleration if input else friction)
	velocity = lerp(velocity, input * stats.max_speed, lerp_weight) * time_scaler.time_scale
	move_and_slide()


func _on_hitbox_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var enemy_body := body as Enemy
		print("Wiz got hit!")
		take_damage(enemy_body.stats.atk_dmg)


func take_damage(dmg_val : int):
	curr_hp -= dmg_val
	print("wiz got damaged with: ", dmg_val)
	if curr_hp <= 0:
		print("ya died!")
		get_tree().quit()
