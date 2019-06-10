require_relative 'table_analysis/core'
require_relative 'table_analysis/version'
require 'nokogiri'
module TableAnalysis
  class Main
    def self.generator(html, *selected_cols)
      selected_cols = selected_cols.flatten 
      doc = Nokogiri::HTML(html, nil, 'utf-8')
      # 多个table,仅处理第一个
      table = doc.xpath('//table')[0]

      header_content_tds = []
      body_content_tds = []
      body_tr_size = 0
      table.xpath('./tr').each_with_index do |tr, tr_index|
        if tr_index == 0
          tr.xpath('./td').each do |td|
            header_name = td.content
            colspan = td.attribute('colspan')&.value
            header_content_tds << [header_name, colspan]
          end
        else
          body_tr_size += 1
          tr.xpath('./td').each_with_index do |td, td_index|
            rowspan = td.attribute('rowspan')&.value 
            colspan = td.attribute('colspan')&.value
            body_content_tds << [rowspan, colspan]
          end
        end
      end

      header_tds = header_content_tds.map do |header_content_td|
        TableAnalysis::HeaderTd.config(header_content_td[0], header_content_td[1])
      end

      header = TableAnalysis::Header.config(selected_cols, header_tds)
      table = TableAnalysis::Table.config(body_tr_size, header)

      body_tds = body_content_tds.map do |body_td|
        TableAnalysis::BodyTd.config(body_td[0], body_td[1])
      end

      content_maps = TableAnalysis::Core.new(header, table, body_tds).entrance

      header_map = [Array.new(header_tds.size){0}]

      table_maps = header_map + content_maps

      p table_maps
      table_maps
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end
