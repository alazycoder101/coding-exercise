# frozen_string_literal: true

# Node: expression tree
class Node
  OPERATORS = { '+': '+', '-': '-', 'x': '*', '÷': '/' }.freeze
  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
    validate
  end

  def validate
    return if @value.is_a?(Numeric)

    raise 'Invalid node' unless @left && @right

    raise "Invalid operator: #{@value}" if OPERATORS[@value.to_sym].nil?
  end

  def result
    return @left.result.send(OPERATORS[@value.to_sym], @right.result) if @left && @right

    @value.to_f
  end

  def leaf?
    !(@left && @right)
  end

  def to_s
    return "(#{@left} #{@value} #{@right})" unless leaf?

    @value.to_s
  end
end

tree = Node.new(
  '÷',
  Node.new(
    '+',
    Node.new(7),
    Node.new(
      'x',
      Node.new('-',
               Node.new(3),
               Node.new(2)),
      Node.new(5)
    )
  ),
  Node.new(6)
)

def assert_equal(expected, actual)
  puts "Expected: #{expected.inspect}, got: #{actual.inspect}" and exit 1 unless expected == actual

  true
end

def assert_error(expected, block)
  block.call
  assert_equal false, true
rescue StandardError => e
  assert_equal(e.message, expected)
end

assert_equal '((7 + ((3 - 2) x 5)) ÷ 6)', tree.to_s
assert_equal 2, tree.result

tree = Node.new(6)
assert_equal '6', tree.to_s
assert_equal 6, tree.result

assert_error('Invalid node', -> { Node.new('+') })
assert_error('Invalid operator: /', -> { Node.new('/', Node.new(1), Node.new(9)) })
