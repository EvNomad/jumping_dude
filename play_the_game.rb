require 'gosu'

class TheGameWindow < Gosu::Window
	def initialize
		super(960, 480)
		self.caption = 'The Game'	
		@background_image = Gosu::Image.new("assets/dark_london.png", :tileable => true)
		
		@hero_images =[]
		@hero_images << Gosu::Image.new("assets/walk_0.png")
		@hero_images << Gosu::Image.new("assets/walk_1.png")
		@hero_images << Gosu::Image.new("assets/walk_2.png")
		@hero_sits = Gosu::Image.new("assets/sit_0.png")
		@hero_jump = []
		@hero_jump << Gosu::Image.new("assets/jump_0.png")
		@hero_jump << Gosu::Image.new("assets/jump_1.png")
		@hero_jump << Gosu::Image.new("assets/jump_2.png")
		@current_hero_image = @hero_images.first
		
		
		@ground_level = 255
		@hero_pos = [100, @ground_level]
		@hero_direction = :right
		@vv = 0
	end

	def button_down(button)
		close if button == Gosu::KbEscape	
  end	

	def draw
		fx = self.width.to_f / @background_image.width.to_f
		fy = self.height.to_f / @background_image.height.to_f
		@background_image.draw(0, 0, 0, fx, fy)

		if @hero_direction == :right
      @current_hero_image.draw(@hero_pos[0], @hero_pos[1], 1)
    else      
      @current_hero_image.draw(@hero_pos[0] + @current_hero_image.width, @hero_pos[1], 1, -1)
    end
		
  end

  def update
  	if Gosu::button_down?(Gosu::KbRight)
      move(:right)      
    elsif Gosu::button_down?(Gosu::KbLeft)
      move(:left)      
    elsif Gosu::button_down?(Gosu::KbDown)
    	sit unless @walking || @jumping
    else 
    	@walking = false
    	@sitting = false  
    end

    jump if Gosu::button_down?(Gosu::KbUp)

    handle_jump if @jumping
  
    if @jumping
    	
    	top_points_speed = -2..2

    	if top_points_speed === @vv
    	   @current_hero_image = @hero_jump[1]
    	else
    		if @vv > top_points_speed.last  
    			@current_hero_image = @hero_jump[0]
    		elsif @vv < top_points_speed.first  
    			@current_hero_image = @hero_jump[2]
    		end	      	
      end	
    elsif @walking     
      step = (Gosu::milliseconds / 100 % 3)
      @current_hero_image = @hero_images[step]
    elsif @sitting
    	@current_hero_image = @hero_sits	
    else
    	@hero_pos = [@hero_pos[0], @ground_level]      
      @current_hero_image = @hero_images[0]
    end
  end

  def sit
  	@sitting = true
  	@hero_pos = [@hero_pos[0], @ground_level + 12]
  end	

  def move(direction)
  	@walking = true
  	if direction == :right
  		@hero_pos[0] += 5
  		@hero_direction = :right
  	else
  		@hero_pos[0] -= 5
  		@hero_direction = :left
  	end
  end

  def jump
  	return if @jumping
  	@jumping = true 
  	@vv = 30
  end

  def handle_jump
  	gravity = 1.15
    @ground_level = 255
    @hero_pos = [@hero_pos[0], @hero_pos[1] - @vv]

    if @vv.round == 0
      @vv = -1
    elsif @vv < 0
      @vv = @vv * gravity
    else
      @vv = @vv / gravity
    end

    if @hero_pos[1] >= @ground_level
      @hero_pos[1] = @ground_level
      @jumping = false
    end
  end 


end

TheGameWindow.new.show
