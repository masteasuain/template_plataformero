extends "res://scripts/stateMachine.gd"

func _ready():
	add_state("idle")
	add_state("run")
	add_state("jump")
	add_state("fall")
	add_state("dead")
	add_state("attack")
	call_deferred("set_state", states.idle)

func _process(delta):
	var keyList = states.keys()

func _input(event):

	if state != states.dead:
			
		if [states.idle, states.run].has(state):		
			if event.is_action_pressed("input_jump"):
				parent.velocity.y = parent.max_jump_velocity
				parent.is_jumping = true
							
		if state == states.jump:
			if event.is_action_released("input_jump") && parent.velocity.y < parent.min_jump_velocity:
				parent.velocity.y = parent.min_jump_velocity
				
			
func _state_logic(delta):	
	if state != states.dead:
		
		if parent.is_attacking:
			set_state(states.attack)
		elif round(parent.velocity.x) == 0:
			set_state(states.idle)
			
		parent._handle_move_input()
		
	if parent.is_dead():
		set_state(states.dead)
	
	parent._apply_movement(delta)
	parent._apply_gravity(delta)

		
func _get_transition(delta):
	match state:
				
		states.idle:
			if !parent.is_on_floor():
				if round(parent.velocity.y) < 0 && parent.is_jumping :
					return states.jump
				elif round(parent.velocity.y) > 0:
					return states.fall			
			elif parent.is_dead():
				return states.dead
			elif round(parent.velocity.x) != 0:
				return states.run
				
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif parent.is_dead():
				return states.dead
			elif round(parent.velocity.x) == 0:	
				return states.idle
				
		states.jump:
			if parent.is_on_floor():
				return states.idle
			elif parent.is_dead():
				return states.dead
			elif parent.velocity.y >= 0:
				return states.fall
		
		states.fall:
			if parent.is_on_floor():
				return states.idle
			elif parent.is_dead():
				return states.dead
			elif parent.velocity.y < 0:
				return states.jump
		
		states.attack:
			if !parent.is_on_floor():
				if parent.velocity.y < 0 && parent.is_jumping :
					parent.is_attacking = false
					return states.jump
				elif parent.velocity.y > 0:
					parent.is_attacking = false
					return states.fall
			elif parent.is_dead():
				return states.dead
			elif round(parent.velocity.x) != 0:			
				parent.is_attacking = false
				return states.run
						
	return null		
				
func _enter_state(new_state, old_state):	
#	pass
	match new_state:
		states.idle:
#			parent.anim_player.play("idle")
			print("idle")
			
		states.run:
#			parent.anim_player.play("run")
			print("run")
			
		states.jump:
#			parent.anim_player.play("jump")
			print("jump")
			
		states.fall:
#			parent.anim_player.play("fall")
			print("fall")

		states.attack:
#			parent.anim_player.play("attack")			
			print("attack")
			
		states.dead:
			if old_state != new_state:
				print("dead")
#				parent.anim_player.play("die")
				


			
func _exit_state(old_state, new_state):
	pass
