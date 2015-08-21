require"pry"
require"json"
require"open-uri"
require "table_print"

class Location
	attr_reader :latitude, :longitude 
	@@api_server_key = "&key=AIzaSyD1-K56-s2HMhsROyTaWbKSl2w2Z4fkKe0"
	@@url = "https://maps.googleapis.com/maps/api/geocode/json?address="
	def cord_finder
		puts "Provide Address"
		@address = gets.chomp
		@address = @address.gsub(" ","+")
		@url_to_search = @@url + @address+ @@api_server_key
		@result = open(@url_to_search)
		@result = JSON.load(@result)
		@address = @result["results"][0]["formatted_address"]
		@longitude= @result["results"][0]["geometry"]["location"]["lng"].to_f	
		@latitude = @result["results"][0]["geometry"]["location"]["lat"].to_f	
	end 
end

class Search
	attr_reader :wanted, :radius
	@@url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
	def initialize(loc_instance)
		@longitude = loc_instance.longitude 
		@latitude = loc_instance.latitude
	end
	def parameters
		puts "What are you searching for?"
		@wanted = "&keyword=" + gets.chomp.gsub(" ","+")
		puts "Search a radius of (miles)?"
		@radius= gets.chomp
		@radius = ((@radius.to_f)*1609.34).to_s
		@radius = "&radius=" + @radius
	end
	def search
		@@api_server_key = "&key=AIzaSyD1-K56-s2HMhsROyTaWbKSl2w2Z4fkKe0"
		@result = (@@url + "location=#{@latitude},#{@longitude}" + @radius + @wanted + @@api_server_key) 
		#binding.pry
		@result = open(@result)
		@result = JSON.load(@result)
		@file = File.new("json","w+")
		@file.puts(@result)
		@file.close
		@result["results"].each do |place|
			SearchResult.new(place)
		end
		tp SearchResult.all
		SearchResult.sort
	end
end
class SearchResult
	@@results = []
	attr_reader :num, :name, :price, :rating, :address, :open
	def initialize(place)
		@num  = @@results.length + 1
		@name = place["name"]
		if @name == nil
			@name  = "Unavailable"
		end
		@price = place["price_level"]
		if @price == nil
			@price  = "Unavailable"
		end
		@rating = place["rating"]
		if @rating == nil
			@rating  = "Unavailable"
		end
		@address = place["vicinity"]
		if @address == nil
			@address  = "Unavailable"
		end
		if place["opening_hours"] != nil 
			@open = place["opening_hours"]["open_now"]
		end 
		if @open == nil
			@open = "Unavailable"
		end
		@@results << self
	end
	def num=(num)
		@num= num
	end
	def self.all
		@@results
	end
	def self.sort
		puts "How would you like to sort?"
		puts "1.Price\n2.Rating\n3.Omit Closed\n4.Done Sorting"
		how_to_sort = gets.chomp
		if how_to_sort == "1" or how_to_sort.downcase == "price"
			@@results.sort_by! do |result|
				result.price.to_f
			end
			@@results.reverse!
			@@results.each_with_index do |result,index|
				result.num=(index+1)
			end
		elsif how_to_sort == "2" or how_to_sort.downcase == "rating"
			@@results.sort_by! do |result|
				result.rating.to_f
			end
			@@results.reverse!
			@@results.each_with_index do |result,index|
				result.num=(index+1)
			end
		elsif how_to_sort == "3" or how_to_sort.downcase == "omit closed"
			@@results.collect! do |result|
				if result.open == true
					result
				end
			end
			@@results.compact!
			@@results.each_with_index do |result,index|
				result.num=(index+1)
			end
		elsif how_to_sort == "4" or how_to_sort.downcase == "done sorting"
		puts "In progress..."
		end
		unless how_to_sort == "4" or how_to_sort.downcase == "done sorting"
			tp SearchResult.all
			self.sort 
		end
	end
end
bob = Location.new
bob.cord_finder
charles = Search.new(bob)
charles.parameters
charles.search