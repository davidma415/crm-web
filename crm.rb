require_relative 'contact'
require 'sinatra'

get '/' do
  redirect to '/home'
end

get '/home' do
  erb :index
end

get '/contacts' do
  @contacts = Contact.all
  erb :contacts
end

get '/contacts/new' do
  erb :new
end

get '/contacts/:id' do
  #params[:id] has the id from the URL
  @contact = Contact.find_by({id: params[:id].to_i})
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

get '/contacts/:id/edit' do
  @contact = Contact.find_by({id: params[:id].to_i})
  if @contact
    erb :edit_contact
  else
    raise Sinatra::NotFound
  end
end

get '/about' do
  erb :about
end

get '/search_contact' do
  erb :search
end

get '/search' do
  first_name = params[:first_name].downcase
  last_name = params[:last_name].downcase
  @contact = Contact.find_by(
    first_name: first_name,
    last_name: last_name
  )
  if @contact
    erb :show_contact
  else
    raise Sinatra::NotFound
  end
end

post '/contacts' do
  first_name = params[:first_name].downcase
  last_name = params[:last_name].downcase
  Contact.create(
    first_name: first_name,
    last_name: last_name,
    email: params[:email],
    note: params[:note]
  )
  redirect to('/contacts')
end

put '/contacts/:id' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    @contact.update(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      note: params[:note]
    )
    redirect to ('/contacts')
  else
    raise Sinatra::NotFound
  end
end

delete '/contacts/:id' do
  @contact = Contact.find_by(id: params[:id].to_i)
  if @contact
    @contact.delete
    redirect to ('/contacts')
  else
    raise Sinatra::NotFound
  end
end

after do
  ActiveRecord::Base.connection.close
end
