class Dial
  attr_reader :num

  def initialize(n = 50)
    @num = n
  end

  # is the dial set at zero?
  def zero?
    @num.zero?
  end

  # returns the number of zeroes
  def rotate(rot)
    if rot.left?
      @num -= rot.num
      if @num.negative?
        @num += 100 while @num < -100
        @num = 100 + @num
      end
    elsif rot.right?
      @num += rot.num
      @num -= 100 while @num >= 100
    end
    zero? ? 1 : 0
  end
end

class Rotation
  attr_reader :direction, :num

  @directions = {'L' => :left, 'R' => :right}

  def self.parse(cmd)
    dir = @directions[cmd[0..0]]
    raise "invalid rotation: #{cmd.inspect}" unless dir

    new(dir, cmd[1..cmd.size].to_i)
  end

  def initialize(direction, num)
    @direction = direction
    @num = num
  end

  def left?
    @direction == :left
  end

  def right?
    @direction == :right
  end
end

class Attempt
  attr_reader :dial, :zeroes

  def self.make(input)
    new.tap { |a| a.make(input) }
  end

  def initialize
    @dial = Dial.new
    @zeroes = 0
  end

  def make(input)
    @zeroes = input.sum do |line|
      @dial.rotate(Rotation.parse(line))
    end
  end
end

input = $stdin.tty? ? %w[L68 L30 R48 L5 R60 L55 L1 L99 R14 L82] : ARGF.readlines
att = Attempt.make(input)

puts "#{input.size} command(s), password: #{att.zeroes}"
