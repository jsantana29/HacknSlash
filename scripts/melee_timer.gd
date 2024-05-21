extends Timer


# Called when the node enters the scene tree for the first time.
func start_chain_timer(duration):
	self.one_shot = true
	self.wait_time = duration
	self.start()
	
func is_chainable():
	return !self.is_stopped()
