extends CharacterBody2D

class_name Enemy

@export var stats : EnemyStats
@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
