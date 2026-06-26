extends CharacterBody2D

class_name Enemy

@export var time_scaler: TimeScaler
@export var stats : EnemyStats
@export var player_combat_stats: CombatStats # this is useless, just use the player reference

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var health_bar: HealthBar = $HealthBar
@export var anim_player : AnimationPlayer
var curr_hp: int

var knockback: Vector2 = Vector2.ZERO
var knockback_timer : float = 0.0
signal send_points(points : int)

func _ready() -> void:
	health_bar.max_value = stats.hp
	health_bar.value = stats.hp
	
	curr_hp = stats.hp

func take_damage(dmg_val : int):
	curr_hp -= dmg_val
	if anim_player:
		anim_player.play("hit")
	health_bar.value = curr_hp
	if curr_hp <= 0:
		send_points.emit(stats.score_points)
		queue_free()

func apply_knockback(direction: Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
