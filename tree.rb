# frozen_string_literal: true

# Node: expression tree
class Node
  OPERATORS = { '+': '+', '-': '-', 'x': '*', '÷': '/' }.freeze
  def initialize(value, operator = nil, left = nil, right = nil)
    @value = value
    @operator = operator&.to_sym
    @left = left
    @right = right
    validate
  end

  def validate
    raise 'Invalid node' if @value.to_s.empty? == @operator.to_s.empty?

    raise "Invalid operator: #{@operator}" if @operator && OPERATORS[@operator].nil?

    raise 'Invalid node' if @operator && !(@left && @right)
  end

  def result
    return @left.result.send(OPERATORS[@operator], @right.result) if @operator && @left && @right

    @value.to_f
  end

  def to_s
    return "(#{@left} #{@operator} #{@right})" if @operator

    @value.to_s
  end
end

tree = Node.new(
  nil,
  '÷',
  Node.new(
    nil,
    '+',
    Node.new(7),
    Node.new(
      nil,
      'x',
      Node.new(nil, '-',
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

assert_error('Invalid node', -> { Node.new(nil, '+') })
assert_error('Invalid operator: /', -> { Node.new(nil, '/') })
