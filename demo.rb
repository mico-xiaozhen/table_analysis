require './lib/table_analysis.rb'

doc = File.read('file/demo3.html')

p TableAnalysis::Main.generator(doc, 1, 2)
