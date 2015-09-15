class SearchResult
	@@results = []
	@array = []
	attr_reader :name, :price, :rating, :address, :open
	attr_accessor :num
	def initialize(place)
		@num  = @@results.length + 1
		@name = place["name"]
		if @name == nil
			@name  = "?"
		end
		@price = place["price_level"]
		if @price == nil
			@price  = "?"
		end
		@rating = place["rating"]
		if @rating == nil
			@rating  = "?"
		end
		@address = place["vicinity"]
		if @address == nil
			@address  = "?"
		end
		if place["opening_hours"] != nil 
			@open = place["opening_hours"]["open_now"]
		end 
		if @open == nil
			@open = "?"
		end
		@@results << self
	end
	def self.all
		@@results
	end
	def self.sort_by_price
		@@results.sort_by! do |result|
			result.price.to_f
		end
		@@results.each do |result|
			if result.price == '?'
				@array << result
			end
		end 
		@@results.map! do |result|
			if result.price != '?'
				result
			end
		end
		@@results.compact! 
		@@results+= @array
		a = File.open("./open", "r+")
		if eval(File.read(a)) == false
			@@results.map! do |result|
				if result.open == true
					result
				end
			end
		end 
		@@results.compact!
		@@results.each_with_index do |result,index|
			result.num=(index+1)
		end
	end
	def self.sort_by_rating
		@@results.sort_by! do |result|
			result.rating.to_f
		end
		@@results.reverse!
		a = File.open("./open", "r+")
		if eval(File.read(a)) == false
			@@results.map! do |result|
				if result.open == true
					result
				end
			end
		end 
		@@results.each_with_index do |result,index|
				result.num=(index+1)
		end
	end 
	def self.sort_by_open
		@@results.collect! do |result|
			if result.open == true
				result
			end
		end
		@@results.compact!
		@@results.each_with_index do |result,index|
			result.num=(index+1)
		end
	end
	def self.sort_by_name
		@@results.sort_by! do |result|
			result.name
		end
		a = File.open("./open", "r+")
		if eval(File.read(a)) == false
			@@results.map! do |result|
				if result.open == true
					result
				end
			end
		end 
		@@results.each_with_index do |result,index|
			result.num=(index+1)
		end
	end
end
		
