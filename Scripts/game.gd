extends Node2D


@export var 敌人生成范围 : float = 50
@export var max_enemy_count : int = 10
# 难度阶段配置数组，每阶段包含时间上限和对应的等待时间
@export var difficulty_stages: Array[Dictionary] = [
	{"time_limit": 30.0, "wait_time": 2.0},
	{"time_limit": 60.0, "wait_time": 1.5},
	{"time_limit": INF, "wait_time": 1.0}
]


# Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass
	

# # Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#enemy_gentime_increase()
	

func gen_enemy():
	var player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null
	var enemy = preload("res://Enemy/Enemy.tscn").instantiate()
	var angle = randf_range(0, TAU)
	var random_dir = Vector2(cos(angle), sin(angle))
	enemy.position = player.position + (random_dir * 敌人生成范围)
	find_child("background").add_child(enemy)

func gen_fastEnemy():
	var player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null
	var enemy = preload("res://Enemy/fast_enemy.tscn").instantiate()
	var angle = randf_range(0, TAU)
	var random_dir = Vector2(cos(angle), sin(angle))
	enemy.position = player.position + (random_dir * 敌人生成范围)
	find_child("background").add_child(enemy)

func _on_timer_ge_enemy_timeout() -> void:
	
	if get_node_count_in_group("Enemy") < max_enemy_count:
		enemy_gentime_increase()
		gen_enemy()
		gen_fastEnemy()


func get_node_count_in_group(group_name: String) -> int:
	var enemies = get_tree().get_nodes_in_group(group_name)
	var valid_count = 0
	for enemy in enemies:
		if is_instance_valid(enemy):
			valid_count += 1
	return valid_count	

# 根据当前游戏运行时间调整定时器等待时间
func enemy_gentime_increase():
	var timer = get_node("Timer_geEnemy") as Timer
	var run_time = Time.get_ticks_msec() / 1000
	#print('run_time=' + str(run_time))
	#print('wait_time=' + str(timer.wait_time))
	for stage in difficulty_stages:
		if run_time <= stage.time_limit:
			timer.wait_time = stage.wait_time
			break
		
# 测试函数：根据运行时间设置定时器等待时间并验证
func test_enemy_gentime_control():
	var timer = get_node("Timer_geEnemy") as Timer
	var run_time = Time.get_ticks_msec() / 1000
	for stage in difficulty_stages:
		if run_time <= stage.time_limit:
			timer.wait_time = stage.wait_time
			assert(timer.wait_time == stage.wait_time, "定时器等待时间应该为" + str(stage.wait_time) + "秒")
			break
