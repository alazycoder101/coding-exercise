class Node
  def initialize(operator, value, left, right)
    @operator = operator
    @value = value
    @left = left
    @right = right
  end

  def result
    case @operator
    when "x"
      @left.result * @right.result
    when "÷"
      @left.result / @right.result
    when "+"
      @left.result + @right.result
    when "-"
      @left.result - @right.result
    else
      @value.to_f
    end
  end

  def to_s
    case @operator
    when "x"
      "(#{@left.to_s} x #{@right.to_s})"
    when "÷"
      "(#{@left.to_s} ÷ #{@right.to_s})"
    when "+"
      "(#{@left.to_s} + #{@right.to_s})"
    when "-"
      "(#{@left.to_s} - #{@right.to_s})"
    else
      @value.to_s
    end
  end
end

tree = Node.new(
  "÷",
  nil,
  Node.new(
    "+",
    nil,
    Node.new("", 7, nil, nil),
    Node.new(
      "x",
      nil,
      Node.new("-", nil,
        Node.new("", 3, nil, nil),
        Node.new("", 2, nil, nil)
      ),
      Node.new("", 5, nil, nil)
    )
  ),
  Node.new("", 6, nil, nil)
);

def assert_equal(expected, actual)
  if expected != actual
    puts "Expected: #{expected.inspect}, got: #{actual.inspect}"
    exit 1
  end
end

assert_equal "((7 + ((3 - 2) x 5)) ÷ 6)", tree.to_s
assert_equal 2, tree.result
