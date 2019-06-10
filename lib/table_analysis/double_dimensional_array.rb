module TableAnalysis
  class DoubleDimensionalArray
    attr_accessor :row, :column

    def initialize(row, column)
      @row = row
      @column = column
    end

    def get_map
      map = []
      @row.times do
        map << Array.new(@column)
      end
      map
    end
  end

  class DDA < DoubleDimensionalArray
    def self.create(row, column)
      new(row, column).get_map
    end
  end
end
