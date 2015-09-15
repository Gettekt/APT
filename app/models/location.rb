class Location
	attr_reader :latitude, :longitude 
	@@api_server_key = "&key=AIzaSyD1-K56-s2HMhsROyTaWbKSl2w2Z4fkKe0"
	@@url = "https://maps.googleapis.com/maps/api/geocode/json?address="
	def initialize(address)
		@address = address
		@address = @address.gsub(" ","+")
		@url_to_search = @@url + @address+ @@api_server_key
		@result = open(@url_to_search)
		@result = JSON.load(@result)
		@address = @result["results"][0]["formatted_address"]
		@longitude= @result["results"][0]["geometry"]["location"]["lng"].to_f	
		@latitude = @result["results"][0]["geometry"]["location"]["lat"].to_f	
	end 
end