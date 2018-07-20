require './reading.rb'

read = read_from('inv').freeze
items = read[1].freeze
totalitems = read[0].freeze
realtotalitemsbyvolume = items.collect(&:mass).reduce(0) { |acc, n| acc + n }
mismatch = realtotalitemsbyvolume - totalitems
def missing_or_more(mismatch)
  "#{mismatch} items #{mismatch < 0 ? 'missing' : 'more'}"
end
mismatch_comm = mismatch.zero? ? 'no mismatch' : missing_or_more(mismatch)
puts "TOTAL ITEMS: declared #{totalitems}, summed by mass #{realtotalitemsbyvolume}, found #{mismatch_comm}"
