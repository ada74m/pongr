require 'thread'

mutex = Mutex.new
resource = ConditionVariable.new

running = true

worker = Thread.new {
	mutex.synchronize {
		while running do 
			resource.wait(mutex)
			puts "tick"
		end
	}
}

sleep(1)

for i in 1..3 do
	mutex.synchronize {
		resource.signal
	}
	sleep(1)
end

running = false