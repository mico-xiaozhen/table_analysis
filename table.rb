module TableAnalysis
  class Table
    def self.config(raw_number, header)
      DDA.create(raw_number, header.size)
    end
  end
end
