require './lib/table_analysis.rb'

doc = File.read('file/demo1.html')

TableAnalysis::Main.generator(doc, 2, 1)
