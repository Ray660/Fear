extends CharacterBody2D

@export var move_speed: float = 30.0
@export var detection_radius: float = 30.0

var orbit_body: Node2D
var enemies_in_range: Array = []  # 玩家周围的敌人列表
var nearest_enemy: Node2D = null

func _ready():
	# 创建环绕物
	orbit_body = find_child("gun")
	add_to_group("Player")
	# 设置玩家检测区域
	setup_player_detection_area()

func setup_player_detection_area():
	var detection_area = Area2D.new()
	detection_area.name = "PlayerDetectionArea"
	detection_area.visible = false
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = detection_radius
	collision_shape.shape = circle_shape

	detection_area.add_child(collision_shape)
	add_child(detection_area)

	# 连接信号
	detection_area.area_entered.connect(_on_body_entered)
	detection_area.area_exited.connect(_on_body_exited)
	
func _physics_process(delta: float) -> void:
	velocity = Input.get_vector("left","right","up","down") * move_speed
	move_and_slide()

	# 更新最近的敌人
	update_nearest_enemy()
	
	# 将最近敌人信息传递给环绕物
	if orbit_body:
		orbit_body.update_target_enemy(nearest_enemy)

func _on_body_entered(body):
	if body.is_in_group("Enemy") and body.is_alive:
		if not body in enemies_in_range:
			enemies_in_range.append(body)

func _on_body_exited(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.erase(body)
		if nearest_enemy == body:
			nearest_enemy = null

func update_nearest_enemy():
	if enemies_in_range.is_empty():
		nearest_enemy = null
		return
	
	# 找到离玩家最近的敌人
	var closest_distance = INF
	var closest_enemy = null

	for enemy in enemies_in_range:
		if enemy.is_alive:
			var distance = global_position.distance_to(enemy.global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_enemy = enemy
	
	nearest_enemy = closest_enemy


#func _draw():
	#pass
	# 绘制玩家检测范围
	#draw_circle(Vector2.ZERO, detection_radius, Color(0, 1, 0, 0.1))
#
	## 绘制指向最近敌人的线
	#if nearest_enemy:
		#draw_line(Vector2.ZERO, to_local(nearest_enemy.global_position), Color(1, 0, 0, 0.7), 3)
