require 'minitest/autorun'
require './kata'

class TestKata < Minitest::Test
  
  def setup
    @lines = %w[
      ........
      ....*...
      ...**...
      ........
    ].unshift( '4 8' )

    @kata = Kata.new( @lines )
  end

  def dimensions( kata )
    return kata.header.split( ' ' ).map( &:to_i )
  end

  def test_header
    assert_equal @lines[0], dimensions( @kata ).join(' ')
  end

  def test_output_is_initialized
    h, w = dimensions( @kata )

    assert( @kata.output.all? { |s| s == '0' * w } )
    assert_equal h, @kata.output.count
  end

  def test_add_neighbour_top_left
    @kata.add_neighbour( 0, 0 )
    correct = %w[
      01000000
      11000000
      00000000
      00000000
    ]
    assert_equal correct, @kata.output
  end

  def test_add_neighbour_top_right
    @kata.add_neighbour( 7, 0 )
    correct = %w[
      00000010
      00000011
      00000000
      00000000
    ]
    assert_equal correct, @kata.output
  end

  def test_add_neighbour_bottom_left
    @kata.add_neighbour( 0, 3 )
    correct = %w[
      00000000
      00000000
      11000000
      01000000
    ]
    assert_equal correct, @kata.output
  end

  def test_add_neighbour_bottom_right
    @kata.add_neighbour( 7, 3 )
    correct = %w[
      00000000
      00000000
      00000011
      00000010
    ]
    assert_equal correct, @kata.output
  end

  def test_add_neighbour_middle
    @kata.add_neighbour( 3, 1 )
    correct = %w[
      00111000
      00101000
      00111000
      00000000
    ]
    assert_equal correct, @kata.output
  end

  def test_add_neighbour_sum
    @kata.add_neighbour( 3, 1 )
    @kata.add_neighbour( 4, 2 )
    correct = %w[
      00111000
      00112100
      00121100
      00011100
    ]
    assert_equal correct, @kata.output
  end

  def test_each_live
    input = @lines.clone
    input.shift

    @kata.each_live do |x, y|
      input[y][x] = '.'
    end

    assert( input.all? { |s| s =~ /^\.+$/ } )
  end

  def test_apply_rules
    @kata.input = %w[
      .........
      *********
    ]

    @kata.output = %w[
      012345678
      012345678
    ]

    correct = %w[
      ...*.....
      ..**.....
    ]

    @kata.apply_rules
    assert_equal correct, @kata.output
  end

  def test_solve
    @kata.solve
    correct = %w[
      ........
      ...**...
      ...**...
      ........
    ].unshift( '4 8' ).join( "\n" )
    assert_equal correct, @kata.output_with_header
  end

end
