#
# This solution exploits the fact that both `input` and `output` are represented as a text.
# We can use strings instead of arrays, and as a bonus we'll get a bunch of helpful string functions.
#
# This way, a grid of cells will be represented as an array of strings.
# The only thing to remember is that a cell is addressed as `grid[y][x]`, the first coordinate is `y`.
#

class Kata
  attr_reader   :header
  attr_accessor :input
  attr_accessor :output

  #
  # Assuming the header is correct, we don't need it, as we have the grid itself.
  # We store it only for the purpose of generating an output.
  # 
  # @output is also a grid, every character corresponds to a character in @input.
  # It is used to store a number of neighbours for each cell (max value is 8).
  # 
  def initialize( lines )
    @input  = lines.clone
    @header = @input.shift
    @output = @input.map { |s| '0' * s.length }
  end

  def output_with_header
    return [ @header, *@output ].join( "\n" )
  end

  #
  # To count a neighbour we should increment all the cells in @output around this one.
  # We iterate over the 3x3 square, taking into account edge cases.
  #
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

  #
  # This iterator executes a block for every live cell.
  # String#scan is used to search for '*' in every raw of the input grid.
  #
  def each_live
    @input.each_with_index do |s, y|
      s.scan( '*' ) do
        x = Regexp.last_match.offset(0).first
        yield x, y
      end
    end
  end

  #
  # After counting neighbours for every cell, we apply the given rules (simplified).
  # 
  # 1. Any cell with exactly 3 neighbours survives.
  # 2. A cell with 2 neighbours survives only if it was alive.
  # 3. All other cells die.
  #
  # String#gsub! is used to substitute all counted numbers in @output with '*' or '.'.
  # That will be the next generation of the grid.
  #
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
