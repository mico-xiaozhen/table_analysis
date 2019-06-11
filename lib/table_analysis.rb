require_relative 'table_analysis/core'
require_relative 'table_analysis/version'
require 'nokogiri'
module TableAnalysis
  class Main
    def self.generator(doc_table_html, header_start_row, *selected_cols)
      selected_cols = selected_cols.flatten 
      doc = Nokogiri::HTML(doc_table_html, nil, 'utf-8')
      # 多个table,仅处理第一个
      table = doc.xpath('//table')[0]
      return false if table.nil?
      header_content_tds = []
      body_content_tds = []
      header_body_content_tds = []
      body_tr_size = 0
      tr_rows = 1

      select_table_tr = table.xpath('./thead/tr|./tbody/tr') 
      if select_table_tr.empty?
        select_table_tr = table.xpath('./tr')
      end

      select_table_tr.each_with_index do |tr, tr_index|
        if tr_index == header_start_row.to_i - 1
          tr.xpath('./td').each do |td|
            colspan = td.attribute('colspan')&.value
            rowspan = td.attribute('rowspan')&.value
            header_content_tds << [rowspan, colspan]
            header_body_content_tds << [rowspan, colspan]
            tr_rows = rowspan.to_i.dup if !rowspan.nil? && rowspan.to_i > 1 && tr_rows < rowspan.to_i 
          end
        elsif tr_index > header_start_row.to_i - 1 && tr_index < header_start_row.to_i - 1 + tr_rows
          tr.xpath('./td').each do |td|
            rowspan = td.attribute('rowspan')&.value 
            colspan = td.attribute('colspan')&.value
            header_body_content_tds << [rowspan, colspan]
          end
        elsif tr_index >= header_start_row.to_i - 1 + tr_rows
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

      header_table = TableAnalysis::Table.config(tr_rows, header)
      header_body_tds = header_body_content_tds.map do |body_td|
        TableAnalysis::BodyTd.config(body_td[0], body_td[1])
      end

      header_maps = TableAnalysis::Core.new(header, header_table, header_body_tds).entrance

      table_maps = header_maps + content_maps

      table_maps
    end
  end

  class Error < StandardError; end
  # Your code goes here...
end
