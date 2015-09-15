class Search
	attr_reader :wanted, :radius
	@@url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
	def initialize(latitude,longitude,radius,wanted)
		@longitude = longitude 
		@latitude = latitude
		@radius = "&radius=" + ((radius.to_f)*1609.34).to_s
		@wanted = "&keyword=" + wanted
	end
	def search
		@@api_server_key = "&key=AIzaSyD1-K56-s2HMhsROyTaWbKSl2w2Z4fkKe0"
		@result = (@@url + "location=#{@latitude},#{@longitude}" + @radius + @wanted + @@api_server_key) 
		@result = open(@result)
		@result = JSON.load(@result)
		@result["results"].each do |place|
			SearchResult.new(place)
		end
	end
end























