extends Area2D

@export var 移动速度: float = 4.0
@export var 转弯速度: float = 10.0
@export var 初始角度: float = 3
@export var 生命值: float = 60

var velocity = Vector2.ZERO
var player: Node2D
var is_alive : bool = true
func _ready():	
	add_to_group("Enemy")
	player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null

	
func _physics_process(delta):
	if 生命值 <= 0 :
		is_alive = false
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(0.5).timeout 
		queue_free()
		
	if is_alive == true:
		move_to(player,移动速度,转弯速度,velocity,delta)
		rotate(初始角度)



func move_to(target: Node2D,move_speed:float,rotation_speed:float,velocity:Vector2,delta):
	if target != null:
		var direction = (target.global_position - global_position).normalized()

		# 平滑旋转到目标方向
		var current_direction = velocity.normalized()
		if current_direction.length() > 0.1:
			var angle_to_target = current_direction.angle_to(direction)
			var rotation_amount = sign(angle_to_target) * min(abs(angle_to_target), rotation_speed * delta)
			# 旋转当前方向
			velocity = velocity.rotated(rotation_amount).normalized() * move_speed
		else:
			# 如果还没有速度，直接设置方向
			velocity = direction * move_speed
		
			# 让子弹朝向移动方向
			rotation = velocity.angle()
			
	position += velocity * delta



func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Bullet"):
		var damege = area.子弹伤害
		生命值 -= damege
