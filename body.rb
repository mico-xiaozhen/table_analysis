module TableAnalysis
  class BodyTd
    attr_accessor :rowspan, :colspan

    def initialize(rowspan, colspan)
      @rowspan = rowspan
      @colspan = colspan
    end

    def self.config(rowspan, colspan)
      new(rowspan, colspan)
    end

    def reserved_seat?
      @colspan != 1 || @rowspan != 1
    end
  end
end
