# frozen_string_literal: true

# ValueNode: expression tree
class ValueNode
  attr_reader :value
  def initialize(value)
    raise 'Invalid value' unless value.is_a?(Numeric)
    @value = value
  end

  def result
    @value.to_f
  end

  def to_s
    @value.to_s
  end
end

class Processor
  OPERATORS = { '+': '+', '-': '-', 'x': '*', '÷': '/' }.freeze
  def self.check_operator(operator)
    raise 'Invalid operator' unless OPERATORS.keys.include?(operator.to_sym)
  end

  def self.process(node)
    node.left.result.send(OPERATORS[node.operator], node.right.result)
  end
end

class Presenter
  def self.show(node)
    return "(#{node.left} #{node.operator} #{node.right})" if node.is_a?(OperationNode)

    node.value.to_s
  end
end

class OperationNode
  attr_reader :left, :right, :operator

  def initialize(left, operator, right)
    Processor.check_operator(operator)
    @operator = operator.to_sym

    @left = left
    @right = right
  end

  def result
    Processor.process(self)
  end

  def to_s
    Presenter.show(self)
  end
end

tree = OperationNode.new(
  OperationNode.new(
    ValueNode.new(7),
    '+',
    OperationNode.new(
      OperationNode.new(
               ValueNode.new(3),
               '-',
               ValueNode.new(2)),
      'x',
      ValueNode.new(5)
    )
  ),
  '÷',
  ValueNode.new(6)
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

tree = ValueNode.new(6)
assert_equal '6', tree.to_s
assert_equal 6, tree.result

assert_error('Invalid value', -> { ValueNode.new('+') })
assert_error('Invalid operator', -> { OperationNode.new( ValueNode.new(1), '/', ValueNode.new(9)) })
