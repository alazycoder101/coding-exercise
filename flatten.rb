# frozen_string_literal: true

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

test = [1, 2, [3, 4, [5, 6], 7], 8]
p test.flatten
