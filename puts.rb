require './reading.rb'

read = read_from(ARGV.empty? ? 'inv' : ARGV[0])
puts read[0]
puts read[1].collect { |x| x.itemline }
