extends "res://Enemy/enemy.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	移动速度 = 移动速度*2
	add_to_group("Enemy")
	player = get_tree().get_nodes_in_group("Player")[0] if get_tree().get_nodes_in_group("Player") else null
	area_entered.connect(_on_area_entered)  # 自动连接

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
