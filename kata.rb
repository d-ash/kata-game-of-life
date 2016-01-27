class Kata
  attr_reader   :header
  attr_accessor :output
  attr_accessor :input

  def initialize( lines )
    @input  = lines.clone
    @header = @input.shift
    @output = @input.map { |s| '0' * s.length }
  end

  def output_with_header
    return [ @header, *@output ].join( "\n" )
  end

  def add_neighbour( x, y )
    min_x = ( x > 0 ? x - 1 : x )
    min_y = ( y > 0 ? y - 1 : y )

    ( min_x .. x + 1 ).each do |a|
      ( min_y .. y + 1 ).each do |b|
        next if a == x && b == y
        if @output[b] && @output[b][a]
          @output[b][a] = ( @output[b][a].to_i + 1 ).to_s
        end
      end
    end
  end

  def each_live
    @input.each_with_index do |s, y|
      s.scan( '*' ) do
        x = Regexp.last_match.offset(0).first
        yield x, y
      end
    end
  end

  def apply_rules
    @output.each_with_index do |s, y|
      s.gsub!( '3', '*' )

      s.gsub!( '2' ) do
        x = Regexp.last_match.offset(0).first
        next ( @input[y][x] == '*' ? '*' : '.' )
      end

      s.gsub!( /[^*]/, '.' )
    end
  end

  def solve
    each_live do |x, y|
      add_neighbour( x, y )
    end

    apply_rules
  end

end
