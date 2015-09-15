class Yelpdata
	attr_reader :pass
	def initialize(name, address)
		@@url ="http://www.yelp.com/search?find_desc="
		@name = name
		@address = address
		@url = @@url + @name.gsub(" ","+").gsub("&","%20") + "&find_loc=" + @address.gsub(" ","+") + "&ns=1"
		agent = Mechanize.new
		page = agent.get(@url)
		a = page.search("li.regular-search-result")
		a.each do |result|
			b = result.search("div.secondary-attributes address")
			if b.text.delete("\n").strip.scan(/^\d+/) == @address.scan(/^\d+/)
		 		c = result.search("a.biz-name")
		 		@pass = "http://yelp.com" + c.attribute("href").value
		 	end
		end
	end
end