extends Node2D

@export var orbit_radius: float = 10.0
@export var orbit_speed: float = 2.0
@export var move_speed: float = 30.0
@export var 初始角度: float = 3.9


var player: Node2D
var target_enemy: Node2D = null
var target_angle: float = 0.0
var current_angle: float = 0.0

func _ready():
	
	
	# 找到玩家节点
	player = get_parent()
	if not player:
		push_error("OrbitBody must be a child of Player!")
		return

func update_target_enemy(enemy: Node2D):
	target_enemy = enemy

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	# 计算目标角度
	calculate_target_angle(delta)
	
	# 平滑移动到目标角度
	update_orbit_position(delta)
	
	# 更新旋转
	update_rotation()

func calculate_target_angle(delta):
	if target_enemy and is_instance_valid(target_enemy):
		# 计算从玩家指向敌人的方向向量
		var direction_to_enemy = (target_enemy.global_position - player.global_position).normalized()
		# 计算敌人相对于玩家的角度
		var enemy_angle = atan2(direction_to_enemy.y, direction_to_enemy.x)
		target_angle = enemy_angle
	else:
		# 没有敌人时继续环绕
		target_angle += orbit_speed * delta

func update_orbit_position(delta):
	# 平滑插值到目标角度
	var angle_diff = fmod(target_angle - current_angle + PI, TAU) - PI
	current_angle += angle_diff * move_speed * delta
	
	# 基于玩家位置计算环绕物位置
	var offset = Vector2(cos(current_angle), sin(current_angle)) * orbit_radius
	position =  offset
	
func update_rotation():
	if target_enemy and is_instance_valid(target_enemy):
		# 朝向敌人
		look_at(target_enemy.global_position)
		rotate(初始角度)
	else:
		# 朝向运动方向（切线方向）
		rotation = current_angle + 初始角度


func _on_timer_timeout() -> void:
	if target_enemy != null:
		var 子弹 = preload("res://Player/bullet.tscn").instantiate()
		子弹.global_position = global_position
		子弹.get_enemy(target_enemy)
		get_tree().current_scene.add_child(子弹)

	
