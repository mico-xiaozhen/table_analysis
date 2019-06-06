require_relative 'double_dimensional_array'
require_relative 'header'
require_relative 'body'
require_relative 'table'

module TableAnalysis
  class Main
    attr_accessor :header, :table, :body_tds, :pointer, :x_max, :y_max

    def initialize(header, table, body_tds)
      @header = header
      @table = table
      @body_tds = body_tds
      @pointer = [0, 0]
      @x_max = table.size - 1
      @y_max = header.size - 1
    end

    # 入场
    def entrance
      @body_tds.each do |body_td|
        current_seat_position = seat_down
        reserved_seat(current_seat_position, body_td.rowspan, body_td.colspan) if body_td.reserved_seat?
      end

      @table
    end

    # 空座位
    def is_unreserved_seat?
      @table[@pointer[0]][@pointer[1]].nil? ? true : false
    end

    # 坐下
    def seat_down
      if is_unreserved_seat?
        @table[@pointer[0]][@pointer[1]] = seat_down_value(@pointer)
        current_seat_position = @pointer.dup
      else
        pointer_increase
        seat_down
      end

      pointer_increase
      current_seat_position
    end

    # 占座
    def reserved_seat(current_seat_position, rowspan, colspan)
      @table[current_seat_position[0] + rowspan - 1][current_seat_position[1]] = -1 if rowspan > 1

      @table[current_seat_position[0]][current_seat_position[1] + colspan - 1] = -1 if colspan > 1
    end

    # 身份值
    def seat_down_value(position)
      @header[position[1]]
    end

    def pointer_increase
      if @pointer[1] < @y_max
        @pointer[1] += 1
      elsif @pointer[1] == @y_max && @pointer[0] < @x_max
        @pointer[1] = 0
        @pointer[0] += 1
      end
    end
  end
end

header_content_tds = [
  ['姓名', 1], ['年龄', 1], ['内容', 2] # [name, colspan]
]

body_content_tds = [
  [1, 1], [1, 1], [1, 1], [1, 1], # //tr//td [rowspan, colspan]
  [1, 2], [1, 1], [1, 1],
  [1, 1], [1, 1], [1, 2]
]

find_name = '姓名'
tr_sizes = 3

headerTds = header_content_tds.map do |header_content_td|
  TableAnalysis::HeaderTd.config(header_content_td[0], header_content_td[1])
end

header = TableAnalysis::Header.config(find_name, headerTds)
table = TableAnalysis::Table.config(tr_sizes, header)

body_tds = body_content_tds.map do |body_td|
  TableAnalysis::BodyTd.config(body_td[0], body_td[1])
end

p TableAnalysis::Main.new(header, table, body_tds).entrance
