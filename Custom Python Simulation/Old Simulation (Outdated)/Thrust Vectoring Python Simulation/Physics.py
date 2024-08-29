import numpy as np
#input_force_vector = [Fx,Fz,Tau]
'''
		Y+
		|
		|<=
		|	=
		| = Theta
		----------X+

'''
class threeDofPhysics():
	def __init__(self,initial_state_vector,mass,mmoi):
		self.state_vector = initial_state_vector
		self.mass = mass
		self.mmoi = mmoi
		self.input_last = None
		self.actuator_state = []
	def inputForces(self,input_force_vector,dt,internal_gravity = True,negative_x_pos = False):
		G = -9.18 if internal_gravity else 0
		self.state_vector["ay"] = (input_force_vector[0] / self.mass) + G
		self.state_vector["ax"] = input_force_vector[1] / self.mass
		self.state_vector["alpha"] = input_force_vector[2] / self.mmoi
		self.state_vector["vy"] += self.state_vector["ay"] * dt
		self.state_vector["vx"] += self.state_vector["ax"] * dt
		self.state_vector["omega"] += self.state_vector["alpha"] * dt
		self.state_vector["py"] += self.state_vector["vy"] * dt
		if negative_x_pos and self.state_vector["py"] < 0:
			self.state_vector["py"] = 0
		self.state_vector["px"] += self.state_vector["vx"] * dt
		self.state_vector["theta"] += self.state_vector["omega"] * dt
		return self.state_vector
	#maybe eventually replace this with an "Actuator" class or something that can command stuff
	def tvcPhysics(self,input_angle,thrust,vehicle,dt,print_warnings = False): #angle in rads
		if input_angle > vehicle.servo_lim:
			input_angle = vehicle.servo_lim
			print("WARNING: Acuator Limit Reached") if print_warnings else None
		if input_angle < - vehicle.servo_lim:
			input_angle = -vehicle.servo_lim
			print("WARNING: Acuator Limit Reached") if print_warnings else None
		if self.input_last is None:
			self.input_last = input_angle 
		servo_rate = (self.input_last - input_angle) / dt
		if servo_rate > vehicle.servo_rate_lim:
			input_angle = self.input_last - vehicle.servo_rate_lim*dt
			print("WARNING: Acuator Rate Limit Reached") if print_warnings else None
		if servo_rate < -vehicle.servo_rate_lim:
			input_angle = self.input_last + vehicle.servo_rate_lim*dt
			print("WARNING: Acuator Rate Limit Reached") if print_warnings else None
		Fz = np.sin(self.state_vector["theta"])*np.sin(input_angle) * thrust
		Fx = np.cos(self.state_vector["theta"])*np.cos(input_angle) * thrust
		Tau = np.sin(input_angle) * thrust * vehicle.com2TVC
		self.actuator_state = input_angle
		self.input_last = input_angle
		return [Fx,Fz,Tau]
