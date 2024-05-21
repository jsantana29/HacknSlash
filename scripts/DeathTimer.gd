extends Timer


# Called when the node enters the scene tree for the first time.
func start_death(duration):
	self.one_shot = true
	self.wait_time = duration
	self.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func is_dying():
	#print(self.time_left)
	return !self.is_stopped()
