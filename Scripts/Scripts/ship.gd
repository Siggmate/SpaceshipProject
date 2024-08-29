extends CharacterBody2D

var speed := 150
var acc := 2
var friction := 5
var hp := 100
var invincible := false
@onready var hurtbox: Area2D = $Hurtbox
@onready var animations = $Animations
@onready var healthbar = $Node2D/Healthbar
@onready var inv_timer = $InvTimer
@onready var death_particle = $DeathParticle

func _ready():
	healthbar.set_value(hp)
	hurtbox.body_entered.connect(_on_hurtbox_body_entered)

func _process(delta):
	move()
	if hp <= 0:
		death()

func move():
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO:
		accelerate(direction)
	else:
		apply_friction()
	move_and_slide()

func accelerate(direct: Vector2):
	velocity = velocity.move_toward(direct * speed, acc)
	
func apply_friction():
	velocity = velocity.move_toward(Vector2.ZERO, friction)
	
func _on_hurtbox_body_entered(body):
	if invincible == false:
		invincible = true
		inv_timer.start()
		animations.play("flash")
		hp -= body.dmg
		healthbar.set_value(hp)

func _on_inv_timer_timeout():
	invincible = false

func death():
	#death_particle.restart()
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
