# frozen_string_literal: true

# Node: operation tree
class Node
  OPERATORS = { '+': '+', '-': '-', 'x': '*', '÷': '/' }.freeze
  def initialize(value, operator=nil, left=nil, right=nil)
    @value = value
    @operator = operator
    @left = left
    @right = right
  end

  def result
    if @operator && @left && @right
      operator = OPERATORS[@operator.to_sym]
      puts "Operator: #{@operator} not exist" and return unless operator

      return @left.result.send(operator, @right.result)
    end

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

assert_equal '((7 + ((3 - 2) x 5)) ÷ 6)', tree.to_s
assert_equal 2, tree.result
