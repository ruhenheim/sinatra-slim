require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require 'slim'

require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper ### to use `time_ago_in_words` helper-method

set :database, {adapter: "sqlite3", database: "development.sqlite3"}
# or set :database_file, "path/to/database.yml"

class BlogApp < Sinatra::Base
  enable :method_override
  enable :sessions
  register Sinatra::Flash
  # routing
  get '/' do
    slim :dashboard
  end
  get '/blog' do
    @posts = Post.order(updated_at: :desc)
    slim :"blog/index"
  end
  get '/blog/new' do
    @post = Post.new
    slim :"blog/new"
  end
  get %r{/blog/(?<post_id>[0-9]+)} do
    @post = Post.find(params[:post_id])
    slim :"blog/show"
  end
  post '/blog' do
    @post = Post.new(title: params[:title], content: params[:content])
    if @post.save
      redirect to('/blog')
    else
      flash.now[:warning] = "投稿できませんでした."
      slim :"blog/new"
    end
  end
  delete '/blog/:id' do
    post = Post.find(params[:id])
    post.destroy
    redirect to('/blog')
  end

end


require './models/post'
