extends "res://Player/gun.gd"

@export var 武器伤害 : float = 50
var Timer1 : Timer
var Level : int = 0
var last_level : int = 0
var current_animal : String
var enemies_touched: Array = []  # 玩家周围的敌人列表
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Timer1 = find_child("Timer")
	Timer1.wait_time = 发射间隔
	初始角度 = 0
	orbit_speed = 1
	# 找到玩家节点
	player = get_parent()
	if not player:
		push_error("OrbitBody must be a child of Player!")
		return
	add_to_group("sword")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Level != last_level:
		current_animal = "level" + str(Level)
		$AnimatedSprite2D.play(current_animal)
		last_level = Level

	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
		attcak(area)
		enemies_touched.append(area)
		Timer1.start()

func _on_area_exited(area: Area2D) -> void:
	enemies_touched.erase(area)


func _on_timer_timeout() -> void:
	for enemy_oneof in enemies_touched:
		attcak(enemy_oneof)


func Level_up() -> void:
	Level += 1
	
func attcak(target_enemy:Area2D) -> void:
	target_enemy.生命值 -= 武器伤害
	$AnimatedSprite2D/hurt.play()
	if target_enemy.is_alive and target_enemy.生命值 <= 0 and Level != 5:
		Level_up()
	
