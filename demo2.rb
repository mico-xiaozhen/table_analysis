require_relative 'main'
require 'nokogiri'

doc = File.open('file/demo2.html') { |f| Nokogiri::HTML(f, nil, 'utf-8') }
tables = doc.xpath('//table')
tables.each do |table|
  header_content_tds = []
  body_content_tds = []
  tr_sizes = 0 
  table.xpath('./tr').each_with_index do |tr, index|
    if index == 0
      tr.xpath('./td').each do |td|
        header_name = td.content
        colspan = td.attribute('colspan')&.value
        header_content_tds << [header_name, colspan] 
      end
    else
      tr_sizes += 1 
      tr.xpath('./td').each do |td|
        rowspan = td.attribute('rowspan')&.value 
        colspan = td.attribute('colspan')&.value
        body_content_tds << [rowspan, colspan] 
      end
    end
  end
  # p header_content_tds
  # p body_content_tds
  p find_name = header_content_tds[1][0].delete('\n').strip
  headerTds = header_content_tds.map do |header_content_td|
    TableAnalysis::HeaderTd.config(header_content_td[0], header_content_td[1])
  end
  # p headerTds
  header = TableAnalysis::Header.config(find_name, headerTds)
  table = TableAnalysis::Table.config(tr_sizes, header)
  # p header 
  body_tds = body_content_tds.map do |body_td|
    TableAnalysis::BodyTd.config(body_td[0], body_td[1])
  end
  # p body_tds 
  p TableAnalysis::Main.new(header, table, body_tds).entrance
end
