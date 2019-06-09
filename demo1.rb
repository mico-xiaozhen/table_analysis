require_relative 'main'

header_content_tds = [
  ['姓名', 1], ['年龄', 1], ['内容', 2] # [name, colspan]
]

body_content_tds = [
  [1, 1], [1, 1], [1, 1], [1, 1], # //tr//td [rowspan, colspan]
  [3, 1], [1, 1], [1, 1], [1, 1],
  [1, 1], [1, 1], [1, 1],
  [1, 1], [1, 1], [1, 1]
]

find_name = '姓名'
tr_sizes = 4

headerTds = header_content_tds.map do |header_content_td|
  TableAnalysis::HeaderTd.config(header_content_td[0], header_content_td[1])
end

header = TableAnalysis::Header.config(find_name, headerTds)
table = TableAnalysis::Table.config(tr_sizes, header)

body_tds = body_content_tds.map do |body_td|
  TableAnalysis::BodyTd.config(body_td[0], body_td[1])
end

p TableAnalysis::Main.new(header, table, body_tds).entrance
