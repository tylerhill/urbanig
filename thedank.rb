require 'sinatra'
require 'instagram'
require 'liquid'
set :views, settings.root + '/app/views'

enable :sessions

CALLBACK_URL = 'https://protected-forest-6085.herokuapp.com/oauth/callback'

Instagram.configure do |config|
  config.client_id = '0a28ee9a6bb84eb29745d2499a96d759'
  config.client_secret = '512403d85abd46b0acdd97a44b8b4ac0'
end

get '/' do
  client = Instagram.client(:access_token => session[:access_token])
  user = client.user
  @igConfig = {
    :count => 2
  }
  @recent = client.user_recent_media(@igConfig)
  @srcs = []
  @recent.each do |pic|
    @srcs << pic.images.thumbnail.url
  end
  puts YAML::dump(@srcs)
  
  liquid :index, :locals => { :recent => @srcs }
  
end


#get '/' do 
#  '<a href="/oauth/connect">Connectttt</a>'
#end
#
#get '/oauth/connect' do
#  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
#end
#
#get '/oauth/callback' do
#  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
#  session[:access_token] = response.access_token
#  redirect '/nav'
#end


