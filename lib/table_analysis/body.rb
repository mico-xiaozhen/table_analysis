module TableAnalysis
  class BodyTd
    attr_accessor :rowspan, :colspan

    def initialize(rowspan, colspan)
      @rowspan = rowspan.nil? ? 1 : rowspan.to_i

      @colspan = colspan.nil? ? 1 : colspan.to_i
    end

    def self.config(rowspan, colspan)
      new(rowspan, colspan)
    end

    def reserved_seat?
      @colspan != 1 || @rowspan != 1
    end
  end
end
