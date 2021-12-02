# frozen_string_literal: true

# Array
class Array
  def flatten
    inject([]) do |result, element|
      if element.is_a?(Array)
        result + element.flatten
      else
        result << element
      end
    end
  end
end

def assert_equal(expected, actual)
  puts "Expected: #{expected.inspect}, got: #{actual.inspect}" and exit 1 unless expected == actual

  true
end

test = [1, 2, [3, 4, [5, 6], 7], 8]
p test.flatten

assert_equal([1, 2], [1, 2].flatten)
assert_equal([], [].flatten)
assert_equal([1, 2], [[[[1, 2]]]].flatten)
assert_equal([1, 2, nil], [[], [1, 2, nil], [], []].flatten)
assert_equal([1, 2, 3, 4, 5, 6, 7, 8], test.flatten)
