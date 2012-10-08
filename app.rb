

require 'sinatra'


get "/" do
  erb :index
end


get "/principal.html" do
  erb :principal
end

get "/objetivos.html" do
  erb :objetivos
  

end
get "/mensajes.html" do
  erb :mensajes
  

end