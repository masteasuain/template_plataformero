extends KinematicBody2D

const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const SLOPE_STOP = 0

var velocity = Vector2.ZERO
var max_jump_velocity = -200
var min_jump_velocity 

export (float) var move_speed = 6 * 64
export (float) var max_jump_height = 4 * 64
export (float) var min_jump_height = 1 * 64
export (float) var jump_duration = 0.5 

var gravity = 1600
var accelerate = 2.5

var is_grounded
var was_grounded

var is_dead = false
var is_jumping = false
var is_attacking = false
var is_invulnerable = false

onready var anim_player = $AnimationPlayer
var footstep = load("res://sfx/02-footstep.ogg")

func _ready():
	max_jump_velocity = -sqrt(2 * gravity * max_jump_height)
	min_jump_velocity = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta):
	if !is_dead:
		_handle_move_input()
		
func _apply_gravity(delta):
	$AnimationPlayer.play()
	velocity.y += gravity * delta

		
	
func _apply_movement(delta):
	
	$AnimationPlayer.play()
	if is_jumping && velocity.y >= 0:
		is_jumping = false
				
		
	if is_dead:
		velocity.x = 0
			
	var snap = Vector2.DOWN * Globals.TILE_SIZE / 2 if !is_jumping else Vector2.ZERO
		
	velocity = move_and_slide_with_snap(velocity, snap, UP)
			
	is_grounded = _check_is_grounded()
	if !was_grounded && is_grounded:
		$Footsteps.stream = footstep
		$Footsteps.play()
			
	was_grounded = is_grounded
	

func _handle_move_input():
#	if !Globals.wingame:
	var move_direction = -int(Input.is_action_pressed("input_left")) + int(Input.is_action_pressed("input_right"))
		
	if move_direction == -1:		
		$Sprite.scale.x = -1
	elif move_direction == 1:
		$Sprite.scale.x = 1	
					
	velocity.x = lerp(velocity.x, move_speed * move_direction, _get_h_weight())
		
func _get_h_weight():
	return 0.2 if is_grounded else 0.1
					
func _check_is_grounded():
	return is_on_floor()

func is_dead():
	return is_dead
