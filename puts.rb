require './reading.rb'

read = read_from('inv')
puts read[0]
puts read[1].collect { |x| x.itemline }
