require './lib/table_analysis.rb'

doc = File.read('file/demo1.html')

TableAnalysis::Main.generator(doc, 3, 1)
