# 敌人生成系统 - 需求文档

## 概述
实现一个敌人生成系统，在玩家周围的环形区域定时生成敌人，并具有动态难度缩放功能。

## 核心需求

### 1. 生成位置
- **坐标系**：世界坐标
- **生成位置**：以玩家（scarecrow）为圆心的环形区域
  - 圆心：玩家当前位置
  - 最小半径：避开玩家的安全距离（不可靠玩家太近）
  - 最大半径：固定范围（具体数值待定，可配置）
  - 随机分布：在环形区域内随机位置生成
- **背景节点**：生成的敌人挂载在 Background 节点下

### 2. 生成时机
- **方式**：基于定时器的生成（Godot Timer 节点）
- **动态间隔**：根据游戏进度动态调整
  - 随时间递减（游戏进程越久生成越快）
  - 示例：初始间隔 5 秒，可降至 1 秒
- **可配置**：初始间隔、最小间隔、变化速率

### 3. 敌人数限制
- **上限**：屏幕上最多同时存在 10 个敌人
- **行为**：达到上限时停止生成
- **后续**：可配置参数，方便后续调整

### 4. 难度缩放

#### 4.1 生成频率
- 生成间隔随游戏时间增加而递减
- 公式选项：
  - 线性：`interval = max(initial * (1 - time * factor), min_interval)`
  - 指数：`interval = max(initial * exp(-time * factor), min_interval)`

#### 4.2 敌人属性
- 敌人属性随时间增强：
  - 移动速度
  - 转弯速度
  - 初始角度/旋转速度
- 基于已游戏时间进行缩放

### 5. 实现细节

#### 5.1 组件
- **EnemySpawner** 脚本
- **Timer** 节点用于定时生成
- **Background** 节点引用（通过 `find_child` 查找）
- **Player** 节点引用（用于获取圆心和生成位置计算）

#### 5.2 核心函数
```
_ready()
  - 设置定时器
  - 连接 timeout 信号
  - 设置初始间隔
  - 获取 Player 节点引用
  - 获取 Background 节点引用

_on_timer_timeout()
  - 检查敌人数
  - 如果未达上限：
    - 计算生成位置
    - 实例化敌人
    - 应用难度缩放
  - 更新下次生成的间隔

calculate_spawn_position() -> Vector2
  - 获取玩家当前位置（圆心）
  - 获取最小半径（安全距离）
  - 获取最大半径（生成范围）
  - 返回环形区域内的随机位置

apply_difficulty_scaling(enemy: Node2D)
  - 基于游戏时间缩放敌人属性
  - 将缩放后的值应用于敌人

get_background_node() -> Node2D
  - 通过 find_child 查找 Background 节点
  - 返回 Background 节点引用
```

### 6. 配置参数

```gdscript
@export var max_enemies: int = 10                    # 最大敌人数
@export var initial_spawn_interval: float = 5.0     # 初始生成间隔（秒）
@export var min_spawn_interval: float = 1.0         # 最小生成间隔（秒）
@export var interval_decay_rate: float = 0.1        # 间隔衰减速率（每秒）

# 生成范围配置
@export var min_spawn_radius: float = 100.0         # 最小半径（安全距离）
@export var max_spawn_radius: float = 300.0          # 最大半径（待定）

# 难度缩放
@export var speed_increase_per_minute: float = 2.0          # 每分钟速度增量
@export var turn_speed_increase_per_minute: float = 1.0    # 每分钟转弯速度增量
```

### 7. 敌人生成流程

```
1. 定时器触发
2. 检查当前敌人数是否 < max_enemies
3. 获取玩家位置作为圆心
4. 计算环形区域内的随机位置
5. 实例化 enemy.tscn
6. 设置位置为随机位置
7. 应用难度缩放（基于游戏时间）
8. 添加到 Background 节点下
9. 重置定时器（应用新的间隔时间）
```

### 8. Virus 行为

- **追踪**：生成后自动追踪玩家
- **复用**：使用现有的 enemy.tscn
- **挂载**：作为 Background 节点的子节点

## 技术说明

- 使用 `find_child()` 获取 Background 节点
- 生成位置应为世界坐标
- 环形区域随机位置计算：
  - 角度：0 ~ 2π 随机
  - 半径：min_spawn_radius ~ max_spawn_radius 之间随机
  - 位置 = 圆心 + Vector2(cos(angle), sin(angle)) * radius
- 跟踪游戏时间用于难度计算

## 后续扩展

- 一波生成多个敌人而非单个
- 不同类型的敌人有不同的生成逻辑
- 玩家死亡后的生成冷却时间
- 不同难度区域的生成区
- 根据画布大小动态调整生成范围
