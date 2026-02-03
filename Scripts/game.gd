extends Node2D


@export var 敌人生成范围 : float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var enemy = preload("res://Enemy/enemy.tscn").instantiate()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func genEnemy():
	var player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null
	var enemy = preload("res://Enemy/enemy.tscn").instantiate()
	var angle = randf_range(0, TAU)
	var random_dir = Vector2(cos(angle), sin(angle))
	enemy.position = player.position + (random_dir * 敌人生成范围)
	find_child("background").add_child(enemy)


func _on_timer_ge_enemy_timeout() -> void:
	genEnemy()
