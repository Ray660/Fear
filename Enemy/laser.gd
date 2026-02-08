extends Area2D
@export var 激光伤害 : int = 100

var sword : Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sword = find_parent("sword")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if sword.Level == 5 and Input.is_action_just_pressed("active"):
		$AnimatedSprite2D.play("attack")
		sword.orbit_speed = 0
		await get_tree().create_timer(1.2).timeout  
		var areas = get_overlapping_areas()
		for area in areas:
			if area.is_in_group("Enemy"):
				area.生命值 -= 激光伤害
		await get_tree().create_timer(0.3).timeout  
		sword.orbit_speed = 1
		sword.Level = 0

			
