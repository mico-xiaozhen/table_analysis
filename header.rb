module TableAnalysis
  class Header
    def self.config(name, *trs)
      result = []
      trs.flatten.each do |tr|
        result << Array.new(tr.length) { tr.name.to_s == name.to_s ? 1 : 0 }
      end
      result.flatten
    end
  end

  class HeaderTd
    attr_accessor :name, :length
    def initialize(name, length)
      @name = name
      @length = length
    end

    def self.config(name, length)
      new(name, length)
    end
  end
end
