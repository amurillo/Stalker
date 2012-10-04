require 'sinatra'
require 'mogli'

get "/auth/facebook" do
  session[:at]=nil
  redirect authenticator.authorize_url(:scope => 'publish_actions,user_likes,user_photos,user_photo_video_tags,friends_hometown,friends_birthday', :display => 'index.erb')
end

get "/" do
  redirect "/auth/facebook" unless session[:at]
  @client = Mogli::Client.new(session[:at])
  # limit queries to 15 results
  @client.default_params[:limit] = 15
  @app  = Mogli::Application.find(ENV["FACEBOOK_APP_ID"], @client)
  @user = Mogli::User.find("me", @client)
  # Randomly pick a friend
  @friend = @user.friends(:name, :gender, :hometown,:birthday).sort_by {rand}.first unless @friend
  erb :index
end