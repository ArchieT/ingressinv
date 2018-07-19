module reading
	class Item
		@count = 1
		def same(y)
			return false
		end
	end
	class Shield < Item
		@type = :shield
		RARITIES = [:common, :rare, :veryrare :axa]
		def initialize(rarity)
			if RARITIES.include? rarity then
				@rarity = rarity
			end
		end
		def same(y)
			return @type==y.type and @rarity==y.rarity
		end
	end
	class RarityItem < Item
		RARITIES = [:common, :rare, :veryrare]
		def initialize(rarity)
			if RARITIES.include? rarity then
				@rarity = rarity
			end
		end
		def same(y)
			return @type==y.type and @rarity==y.rarity
		end
	end
	class HackMod < RarityItem
		TYPES = [:heatsink, :multihack]
	end
	class HeatSink < HackMod
		@type = :heatsink
	end
	class MultiHack < HackMod
		@type = :multihack
	end
	class Transmuter < Item
		@type = :transmuter
		ITOTYPES = [:minus, :plus]
		def initialize(itotype)
			if ITOTYPES.include? itotype then
				@itotype = itotype
			end
		end
		def same(y)
			return @type==y.type and @itotype==y.itotype
		end
	end
	class NiaItem < Item
		TYPES = [:portalfracker, :beacon]
	end
	class PortalFracker < NiaItem
		@type = :portalfracker
		def initialize()
		end
		def same(y)
			return @type==y.type
		end
	end
	class Beacon < NiaItem
		@type = :beacon
		def initialize(beacontype)
			if [:niantic].include? beacontype then
				@beacontype = beacontype
			end
		end
		def same(y)
			return @type==y.type and @beacontype==y.beacontype
		end
	end
	class FlipVirus < Item
		@type = :flipvirus
		def initialize(virustype)
			if [:ada, :jarvis].include? virustype then
				@virustype = virustype
			end
		end
		def same(y)
			return @type==y.type and @virustype==y.virustype
		end
	end
	class LeveledItem < Item
		TYPES = [:resonator, :xmp, :ultrastrike]
		def initialize(level)
			if [ 1, 2, 3, 4, 5, 6, 7, 8 ].include? level then
				@level = level
			end
		end
		def same(y)
			return @type==y.type and @level==y.level
		end
	end
	class Bomb < LeveledItem
		TYPES = [:xmp, :ultrastrike]
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
		def initialize(level)
			if [ 1, 2, 3, 4, 5, 6, 7, 8, :circlek, :lawson ].include? level then
				@level = level
			end
		end
		def same(y)
			return @type==y.type and @level==y.level
		end
	end
	class LinkAmping < Item
		TYPES = [:linkamp, :softbankultralink]
		def initialize()
		end
	end
	class LinkAmp < LinkAmping
		@type = :linkamp
	end
	class SoftBankUltraLink < LinkAmping
		@type = :softbankultralink
	end
	class FAT < Item
		@type = :fat
		def initialize(fattype)
			if [:forceamp, :turret].include? fattype then
				@fattype = fattype
			end
		end
	end
	class Capsule < Item

	def read_from(filename)

		IO.foreach(filename){
			|l| 
		}
	end
end
