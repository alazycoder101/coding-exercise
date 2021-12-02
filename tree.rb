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

class Operator
  OPERATORS = { '+': '+', '-': '-', 'x': '*', '÷': '/' }.freeze
  RIGHT_OPERATORS = { 'sin': 'Math.sin' }.freeze

  def self.for(node)
    Operator.new(node)
  end

  def self.check(node)
    raise 'Invalid operator' unless OPERATORS.keys.include?(node.operator.to_sym) || RIGHT_OPERATORS.keys.include?(node.operator.to_sym)

    raise 'missing right param' if RIGHT_OPERATORS.keys.include?(node.operator.to_sym) && !node.right

    raise 'missing parms' if OPERATORS.keys.include?(node.operator.to_sym) && !(node.left && node.right)
  end

  def right?
    RIGHT_OPERATORS.keys.include? @node.operator.to_sym
  end

  def initialize(node)
    @node = node
    @operator = OPERATORS[@node.operator.to_sym] || RIGHT_OPERATORS[@node.operator.to_sym]
  end

  def execute
    if right?
      parts = @operator.split('.')
      return Object.const_get(parts[0]).send(parts[1], @node.right.result)
    end
    @node.left.result.send(@operator, @node.right.result)
  end
end

class Presenter
  attr_reader :node

  def self.show(node)
    Presenter.for(node).show
  end

  def self.for(node)
    Presenter.new(node)
  end

  def initialize(node)
    @node = node
  end

  def show
    return "(#{node.left} #{node.operator} #{node.right})" if node.is_a?(OperationNode)

    node.value.to_s
  end
end

class OperationNode
  attr_reader :left, :right, :operator

  def initialize(left, operator, right)
    @operator = operator.to_sym

    @left = left
    @right = right
    Operator.check(self)
  end

  def result
    Operator.for(self).execute
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

assert_equal 0.0, OperationNode.new(nil, 'sin', ValueNode.new(0)).result

assert_error('Invalid value', -> { ValueNode.new('+') })
assert_error('Invalid operator', -> { OperationNode.new( ValueNode.new(1), '/', ValueNode.new(9)) })
