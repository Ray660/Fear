extends Node2D


@export var 敌人生成范围 : float = 50
@export var max_enemy_count : int = 10


# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass
	

# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	test_enemy_gentime_control()
	

func gen_enemy():
	var player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null
	var enemy = preload("res://Enemy/enemy.tscn").instantiate()
	var angle = randf_range(0, TAU)
	var random_dir = Vector2(cos(angle), sin(angle))
	enemy.position = player.position + (random_dir * 敌人生成范围)
	find_child("background").add_child(enemy)


func _on_timer_ge_enemy_timeout() -> void:
	enemy_gentime_increase()
	if get_node_count_in_group("Enemy") < max_enemy_count:
		gen_enemy()


func get_node_count_in_group(group_name: String) -> int:
	var enemies = get_tree().get_nodes_in_group(group_name)
	var valid_count = 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			valid_count += 1
	return valid_count	

func enemy_gentime_increase():
	var timer = get_node("Timer_geEnemy") as Timer
	var run_time = Time.get_ticks_msec() / 1000
	print('run_time=' + str(run_time))
	print('wait_time=' + str(timer.wait_time))
	if run_time > 30.0 and run_time <= 60.0:
		timer.wait_time = 1.5
	elif run_time > 60.0:
		timer.wait_time = 1.0
		
func test_enemy_gentime_control():
	var timer = get_node("Timer_geEnemy") as Timer
	var run_time = Time.get_ticks_msec() / 1000
	if run_time <= 30.0:
		timer.wait_time = 2.0
		assert(timer.wait_time == 2.0, "定时器等待时间应该为2.0秒")
	elif run_time > 30.0 and run_time <= 60.0:
		timer.wait_time = 1.5
		assert(timer.wait_time == 1.5, "定时器等待时间应该为1.5秒")
	elif run_time > 60.0:
		timer.wait_time = 1.0
		assert(timer.wait_time == 1.0, "定时器等待时间应该为1.0秒")
