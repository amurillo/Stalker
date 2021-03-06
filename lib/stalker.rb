APP_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

require 'rubygems'
require 'sinatra'
require 'koala'

# register your app at facebook to get those infos
APP_ID = 1103868579752754 # your app id
APP_CODE = 'f64e9b940a97f4ae095e929837937fd4' # your app code
SITE_URL = 'http://hidden-brook-9507.herokuapp.com/' # your app site url

class STALKER < Sinatra::Application
	
	include Koala

	set :root, APP_ROOT
	enable :sessions

	get '/' do
		if session['access_token']
		 	#'You are logged in! <a href="/logout">Logout</a>'
			# do some stuff with facebook here
			# for example:
			@graph = Koala::Facebook::GraphAPI.new(session["access_token"])
			# publish to your wall (if you have the permissions)
			@graph.put_wall_post("Sign up from Stalker!" + Time.now.to_s )
			# or publish to someone else (if you have the permissions too ;) )
			# @graph.put_wall_post("Checkout my new cool app!", {}, "someoneelse's id")
			erb :index
		else
			erb :index
		end		
	end
	

	get '/login' do
		FACEBOOK_SCOPE = 'publish_stream,publish_actions,user_likes,user_photos,user_photo_video_tags,friends_hometown,friends_birthday,read_friendlists'
		# generate a new oauth object with your app data and your callback url
		session['oauth'] = Facebook::OAuth.new(APP_ID, APP_CODE, SITE_URL + 'callback')
		# redirect to facebook to get your code
		redirect session['oauth'].url_for_oauth_code(:permissions => FACEBOOK_SCOPE)
		# redirect session['oauth'].url_for_oauth_code()
	end

	get '/logout' do
		session['oauth'] = nil
		session['access_token'] = nil
		redirect '/'
	end

	#method to handle the redirect from facebook back to you
	get '/callback' do
		#get the access token from facebook with your code
		session['access_token'] = session['oauth'].get_access_token(params[:code])
		redirect '/'
	end

	get '/principal.html' do
		if session['access_token']
			erb :principal
		else
  			redirect '/login'
  		end
	end

	get '/objetivos.html' do
		if session['access_token']
			erb :objetivos
		else
			redirect '/login'
		end
  		
	end

	get '/mensajes' do
		if session['access_token']
			erb :mensajes
		else
			redirect '/login'
		end
  		
	end

	
	get '/index.html' do
		if session['access_token']
			erb :index
		else
			redirect '/login'
		end
  		
	end

		get '/lista' do
		if session['access_token']
			erb :lista
		else
			redirect '/login'
		end
  		
	end
	
	
	def ToCell(tag,values)
    values.map { |c| "<#{tag}>#{c}</#{tag}>" }.join
  end


	def ToTable(table_array,table_class)
 headers = "<tr>" + ToCell('th',table_array[0].keys) + "</tr>"
 cells = table_array.map do |row|
   "<tr>#{ToCell('td',row.values)} <td><a href=\"#{row[id]}\">  <i class='icon-remove'></i> </a></td> </tr>"
   
end.join("\n  ")
	
 table = "<table class=\"#{table_class}\"><thead>#{headers}</thead><tbody>#{cells}</tbody></table>"
end


 end

