module TableAnalysis
  class Header
    def self.config(selected_cols, *trs)
      result = []
      trs.flatten.each do |tr|
        result << Array.new(tr.length)
      end
      result = result.flatten
      selected_cols.each do |selected_col|
        result[selected_col - 1] = 1
      end
      result.map! { |r| r.nil? ? 0 : r }
    end
  end

  class HeaderTd
    attr_accessor :rowspan, :length

    def initialize(rowspan, length)
      @rowspan = rowspan.nil? ? 1 : rowspan.to_i
      @length = length.nil? ? 1 : length.to_i
    end

    def self.config(rowspan, length)
      new(rowspan, length)
    end
  end
end
