class Direction
	attr_reader :base
	def initialize(dest)
		@base = 'https://www.google.com/maps/dir/'
		@dest = dest
		a = File.open("./address_store")
		@origin = (eval(a.read))["address"]
		@base += @origin.gsub(/[ ,]/,"+") + '/' + @dest.gsub(/[ ,]/,"+")
	end
end