module Reading
	class Item
		@count = 1
		def same(_)
			false
		end

		def mass
			@count
		end

		def +(other)
			raise 'not same' unless same(other)
			z = clone
			z.count += other.count
			z
		end

		def *(other)
			raise 'not number 0..2000' unless (0..2000).cover? other
			raise 'more than 2000' unless other.between(0, 2000 / @count)
			z = clone
			z.count = @count * other
			z
		end

		def encapsulable
			true
		end
	end
	class Shield < Item
		@type = :shield
		RARITIES = %i[common rare veryrare axa].freeze

		def initialize(rarity)
			raise 'bad shield rarity' unless RARITIES.include? rarity
			@rarity = rarity
		end

		def same(y)
			@type == y.type && @rarity == y.rarity
		end
	end
	class RarityItem < Item
		RARITIES = %i[common rare veryrare].freeze

		def initialize(rarity)
			raise 'bad rarity' unless RARITIES.include? rarity
			@rarity = rarity
		end

		def same(y)
			@type == y.type && @rarity == y.rarity
		end
	end
	class HackMod < RarityItem
		TYPES = %i[heatsink multihack].freeze
	end
	class HeatSink < HackMod
		@type = :heatsink
	end
	class MultiHack < HackMod
		@type = :multihack
	end
	class Transmuter < Item
		@type = :transmuter
		ITOTYPES = %i[minus plus].freeze

		def initialize(itotype)
			raise 'bad itotype' unless ITOTYPES.include? itotype
			@itotype = itotype
		end

		def same(y)
			@type == y.type && @itotype == y.itotype
		end
	end
	class NiaItem < Item
		TYPES = %i[portalfracker beacon].freeze

		def encapsulable
			false
		end
	end
	class PortalFracker < NiaItem
		@type = :portalfracker

		def initialize; end

		def same(y)
			@type == y.type
		end
	end
	class Beacon < NiaItem
		@type = :beacon
		BEACONTYPES = %i[niantic].freeze

		def initialize(beacontype)
			raise 'bad beacontype' unless BEACONTYPES.include? beacontype
			@beacontype = beacontype
		end

		def same(y)
			@type == y.type && @beacontype == y.beacontype
		end
	end
	class FlipVirus < Item
		@type = :flipvirus
		VIRUSTYPES = %i[ada jarvis].freeze

		def initialize(virustype)
			raise 'bad virustype' unless VIRUSTYPES.include? virustype
			@virustype = virustype
		end

		def same(y)
			@type == y.type && @virustype == y.virustype
		end
	end
	class LeveledItem < Item
		TYPES = %i[resonator xmp ultrastrike].freeze
		LEVELS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

		def initialize(level)
			raise 'bad leveleditem level' unless LEVELS.include? level
			@level = level
		end

		def same(y)
			@type == y.type && @level == y.level
		end
	end
	class Bomb < LeveledItem
		TYPES = %i[xmp ultrastrike].freeze
	end
	class XMP < Bomb
		@type = :xmp
	end
	class UltraStrike < Bomb
		@type = :ultrastrike
	end
	class Resonator < LeveledItem
		@type = :resonator
	end
	class PowerCube < Item
		@type = :powercube
		LEVELS = [1, 2, 3, 4, 5, 6, 7, 8, :circlek, :lawson].freeze

		def initialize(level)
			raise 'bad powercube level' unless LEVELS.include? level
			@level = level
		end

		def same(y)
			@type == y.type && @level == y.level
		end
	end
	class LinkAmping < Item
		TYPES = %i[linkamp softbankultralink].freeze

		def initialize; end
	end
	class LinkAmp < LinkAmping
		@type = :linkamp
	end
	class SoftBankUltraLink < LinkAmping
		@type = :softbankultralink
	end
	class FAT < Item
		@type = :fat
		FATTYPES = %i[forceamp turret].freeze
		def initialize(fattype)
			raise 'bad fattype' unless FATTYPES.include? fattype
			@fattype = fattype
		end
	end
	class Key < Item
		@type = :key
		KEYKINDS = %i[there from souvenir].freeze

		def initialize(keykind)
			raise 'bad keykind' unless KEYKINDS.include? keykind
			@keykind = keykind
		end

		def same(y)
			@type == y.type && @keykind == y.keykind
		end
	end
	class VolumeDoesntMatchContains < StandardError
		def initialize; end

		def reason
			'volume doesnt match contains'
		end
	end
	def alltrue(arr)
		arr.reduce(true) { |acc, that| acc && that }
	end
	class Capsuling < Item
		@type = :capsule
		@volume = 0
		@contains = []
		KINDS = %i[capsule quantum keylocker].freeze
		def initialize(id = '', volume = 0, contains = [])
			@id = id
			@volume = volume
			@contains = contains
			raise 'contains is not an array' unless contains.is_a?(Array)
			raise 'volume is not between 0 and 100' unless (0..100).cover? volume
			raise VolumeDoesntMatchContains	unless volume == contains.count
			raise 'not all are items' unless alltrue(contains.collect { |x| x.same(x) })
		end

		def same(y)
			@type == y.type && @kind == y.kind && @id == y.id && @volume == y.volume && @contains == y.contains
		end

		def mass
			@count + @volume
		end

		def encapsulable
			false
		end
	end
	class JustCapsule < Capsuling
		@kind = :capsule
	end
	class QuantumCapsule < JustCapsule
		@kind = :quantum
	end
	class KeyLocker < Capsuling
		@kind = :keylocker

		def initialize(id = '', volume = 0, contains = [])
			super
			raise 'not all are keys' unless alltrue(contains.collect { |x| x.type == :key })
		end
	end

	def rarity_parse(str)
		case str
		when 'c'
			:common
		when 'r'
			:rare
		when 'vr'
			:veryrare
		end
		raise "bad rarity: #{str}"
	end

	def interpret_item_kind(kind)
		if %r{/^(?<what>[rxuq])(?<level>[1-8])$/} =~ kind
			level = Integer(level)
			case what
			when 'r'
				Resonator.new(level)
			when 'x'
				XMP.new(level)
			when 'u'
				UltraStrike.new(level)
			when 'q'
				PowerCube.new(level)
			end
		elsif %r{/^(?<rarity>(c|r|vr))(?<what>(sh|hs|mh))$/} =~ kind
			rarity = rarity_parse rarity
			case what
			when 'sh'
				Shield.new(rarity)
			when 'hs'
				HeatSink.new(rarity)
			when 'mh'
				MultiHack.new(rarity)
			end
		end
	end

	def read_one_contained(one)
		raise 'there is no colon separating count' unless
			%r{/^(?<kind>[a-z][a-z1-8_\-+]):(?<count>\d\d?\d?)/} =~ one
		interpret_item_kind(kind) * Integer(count)
	end

	def read_cont(cont)
		cont.split(',').collect { |x| interpret_item_kind x }
	end

	def read_caps(caps)
		l = caps.split('/')
		[Integer(l[0]), read_cont(l[1])]
	end

	def read_line(line)
		t = line.split("\t")
		return nil if t.count.zero?
		raise 'tylko jeden wut' if t.count == 1
		# if t.count >= 2
		itemkind = interpret_item_kind t[0]
		if t[1] =~ %r{/^\d{1,4}$/}
			count = t[1]
			return itemkind * count
		elsif t[1] =~ %r{/^\h{8}$/}
			itemkind.id = t[1]
			if t.count >= 3 &&
			   t[2] =~ %r{^(\d\d?\d?\/)?([a-z][a-z1-8_\-+]:\d\d?\d?,?)+$}
				volume, contains = read_caps t[2]
				itemkind.volume = volume
				itemkind.contains = contains
			end
			return itemkind
		end
	end

	def read_from(filename)
		t, *e = IO.readlines(filename)
		[Integer(t), e.collect { |x| read_line x }]
	end
end
