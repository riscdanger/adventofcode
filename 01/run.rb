class Dial
  attr_reader :num

  def zero?
    @num.zero?
  end

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
  end

  def initialize(n = 50)
    @num = n
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

  def left?
    @direction == :left
  end

  def right?
    @direction == :right
  end

  def initialize(direction, num)
    @direction = direction
    @num = num
  end
end

dial = Dial.new
zeroes = 0

input = $stdin.tty? ? %w[L68 L30 R48 L5 R60 L55 L1 L99 R14 L82] : ARGF.readlines
input.each do |line|
  rot = Rotation.parse(line)
  dial.rotate(rot)
  zeroes += 1 if dial.zero?
end

puts "#{input.size} command(s), password: #{zeroes}"
