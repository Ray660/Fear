extends Area2D

@export var 子弹速度 : float = 40
@export var 转弯速度 : float = 2

var target_enemy : Node2D
var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_to(target_enemy,子弹速度,转弯速度,velocity,delta)


func get_enemy(enemy: Node2D):
	target_enemy = enemy

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

func _on_timer_timeout() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "Enemy":
		queue_free()
