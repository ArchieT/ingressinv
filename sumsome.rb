require './reading.rb'

read = read_from(ARGV.empty ? 'inv': ARGV[0]).freeze
items = read[1].freeze
totalitems = read[0].freeze
realtotalitemsbyvolume = items.collect(&:mass).reduce(0) { |acc, n| acc + n }
mismatch = realtotalitemsbyvolume - totalitems
def missing_or_more(mismatch)
  "#{mismatch} items #{mismatch < 0 ? 'missing' : 'more'}"
end
mismatch_comm = mismatch.zero? ? 'no mismatch' : missing_or_more(mismatch)
puts "TOTAL ITEMS: declared #{totalitems}, summed by mass #{realtotalitemsbyvolume}, found #{mismatch_comm}"
nonewrong = true
items.each do |x|
  next unless x.type == :capsule
  rvol, mat = x.real_volume_calculation_and_whether_match
  unless mat
    nonewrong = false
    puts "This capsule really has volume #{rvol}: #{x.itemline}"
  end
end
puts 'All capsules have their declared volume' if nonewrong

puts "\tL" + (1..8).collect(&:to_s).join("--\t--L") + "\tCircK\tLawson"
words = { xmp: 'XMP', resonator: 'Resonr', ultrastrike: 'UltStr', powercube: 'PrCube', multihack: 'MultiH', heatsink: 'HeatSi', shield: 'Shield' }
def arrayof(lenghtafter, fill, first)
  a = Array.new(lenghtafter+1, fill)
  a[0] = first
  return a
end
theacc = [arrayof(8, 0, :resonator), arrayof(8, 0, :xmp),
          arrayof(8, 0, :ultrastrike), arrayof(10, 0, :powercube)]
raracc = [arrayof(4, 0, :shield), arrayof(3, 0, :heatsink), arrayof(3, 0, :multihack)]
wherewhat = {}
wrarwhat = {}
for i in (0..3)
  wherewhat[theacc[i][0]] = i
end
for i in (0..2)
  wrarwhat[raracc[i][0]] = i
end
def level_column(lvl)
  if (1..8).cover? lvl
    lvl
  else
    case lvl
    when :circlek
      9
    when :lawson
      10
    end
  end
end
def rarity_column(rar)
  case rar
  when :common
    1
  when :rare
    2
  when :veryrare
    3
  when :axa
    4
  end
end
items.each do |x|
  if wherewhat.key? x.type
    theacc[wherewhat[x.type]][level_column(x.level)] += x.count
  elsif wrarwhat.key? x.type
    raracc[wrarwhat[x.type]][rarity_column(x.rarity)] += x.count
  elsif x.type == :capsule
    x.contains.each do |x|
      theacc[wherewhat[x.type]][level_column(x.level)] += x.count if wherewhat.key? x.type
      raracc[wrarwhat[x.type]][rarity_column(x.rarity)] += x.count if wrarwhat.key? x.type
    end
  end
end
theacc
  .collect do |oacc|
  oacc.collect do |x|
    if words.key? x
      words[x]
    else
      x.to_s
    end
  end
end
  .each do |x|
  puts x.join("\t")
end
puts ''
puts "\tCOMM\tRARE\tVRARE\tAXA"
raracc
  .collect do |oacc|
  oacc.collect do |x|
    if words.key? x
      words[x]
    else
      x.to_s
    end
  end
end
  .each do |x|
  puts x.join("\t")
end
