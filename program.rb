require "rubygems"
require 'thread'
require "rubygame"

include Rubygame

maximum_resolution = Screen.get_resolution
puts "This display can manage at least " + maximum_resolution.join("x")

default_depth = 0
@screen = Screen.open  maximum_resolution,
                       default_depth,
                       [ HWSURFACE, DOUBLEBUF, FULLSCREEN]

puts "The screen has a color depth of %i bits" % @screen.depth

@screen.show_cursor = false

center = maximum_resolution.collect! {|axis| axis / 2}
radius = maximum_resolution.min - 16
color = [ 0xc0, 0x80, 0x40]
@screen.draw_circle  center, radius, color

@screen.flip

# Wait until a key is pressed
@event_queue = EventQueue.new
@event_queue.enable_new_style_events
until @event_queue.wait().is_a? Events::KeyPressed
end



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