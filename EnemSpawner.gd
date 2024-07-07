extends Node3D

var enemy = preload("res://Enemy.tscn")
var boss = preload("res://Boss.tscn")
@onready var spawns = get_node("../Spawns").get_children()
@onready var upgradeSpawner = $"../UpgradeSpawner"
signal enemDeath
var deathsTillReward = 0
var deathsTillBoss = 10
var won = false
var bossSpawned = false
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enem()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func spawn_enem():
	if won:
		return
	var enem = enemy.instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_enem_death)
	add_child(enem)

func _on_timer_timeout():
	spawn_enem()

func on_enem_death(x, y, z):
	if deathsTillReward <= 1:
		upgradeSpawner.spawnUpgrade(x, y, z)
		deathsTillReward = 4
	else:
		deathsTillReward -= 1
	if deathsTillBoss <= 1 and !bossSpawned:
		spawn_boss()
		bossSpawned = true
	else:
		deathsTillBoss -= 1

func on_boss_death(x, y , z):
	upgradeSpawner.spawnUpgrade(x, y, z)
	won = true

func spawn_boss():
	var enem = boss.instantiate()
	enem.position = spawns[(randi() % spawns.size())].position
	enem.target = $"../PC"
	enem.onDeath.connect(on_boss_death)
	add_child(enem)
