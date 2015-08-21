require"pry"
require"json"
require"open-uri"

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
		#binding.pry	
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
		@result = open(@result)
		@result = JSON.load(@result)
		@file = File.new("json","w+")
		@file.puts(@result)
		@file.close
		end
end




bob = Location.new
bob.cord_finder
charles = Search.new(bob)
charles.parameters
charles.search