require 'sinatra'

class App < Sinatra::Application
	set :database, 'postgres://christopherd@localhost/appetite'
	get '/' do
		erb :home
	end
	get '/info/:sort_method' do
		if params["sort_method"] == 'open'
			w = File.open("./open", "w+")
			w.puts('false')
			w.close
		end
		if params["sort_method"] != 'none'
			y = File.open('./address_store','r')
			x = File.read(y)
			info = eval(x) 
			a = Location.new(info["address"])
			b = Search.new(a.latitude,a.longitude,info["radius"],info["query"])
			b.search 
			SearchResult.send("sort_by_#{params['sort_method']}")
			@results = SearchResult.all
		else
			z = File.open("address_store", "w+")
			z.puts(params)
        	z.close
			a = Location.new(params["address"])
			b = Search.new(a.latitude,a.longitude,params["radius"],params["query"])
			b.search 
			@results = SearchResult.all
			w = File.open("./open", "w+")
			w.puts('true')
			w.close
		end
		erb :result_page
	end
	get '/yelp/:result' do
		name = params['result'].gsub('$','\'').split('+')[0]
		address = params['result'].gsub('$','\'').split('+')[1]
		@name =  name
		@address = address
		erb :yelp
	end
	get '/directions/:result' do	
		address = params['result'].gsub('$','\'').split('+')[0]
		a = Direction.new(address).base
		system("open", a)
	end	

end 
