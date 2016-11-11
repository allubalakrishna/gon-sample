class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]
  include Swagger::Blocks
  swagger_path '/posts/{id}' do
    operation :get do
      key :description, 'Returns a single Post if the user has access'
      key :operationId, 'findPostById'
      parameter do
        key :name, :Authoraization
        key :in, :header
        key :description, 'Authoraization'
        key :required, true
        key :type, :string
      end
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Post to fetch'
        key :required, true
        key :type, :string
        key :format, :int64
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
    operation :patch do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Post to fetch'
        key :required, true
        key :type, :string
        key :format, :int64
      end
      parameter do
        key :name, :post
        key :in, :body
        key :description, 'Post to add to the store'
        key :required, true
        schema do
          key :'$ref', :PostInput
        end
      end
    end
    operation :delete do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Post to fetch'
        key :required, true
        key :type, :string
        key :format, :int64
      end
    end
  end
  swagger_path '/posts' do
    operation :get do
      key :description, 'Returns all Post from the system that the user has access to'
      key :operationId, 'findPosts'
      key :produces, [
        'application/json',
        'text/html',
      ]
      parameter do
        key :name, :limit
        key :in, :query
        key :description, 'maximum number of results to return'
        key :required, false
        key :type, :integer
        key :format, :int32
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Post
          end
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
    operation :post do
      key :description, 'Creates a new Post in the store.  Duplicates are allowed'
      key :operationId, 'addPost'
      key :produces, [
        'application/json'
      ]
      parameter do
        key :name, :post
        key :in, :body
        key :description, 'Post to add to the store'
        key :required, true
        schema do
          key :'$ref', :PostInput
        end
      end
      response 200 do
        key :description, 'Post response'
        schema do
          key :'$ref', :Post
        end
      end
      response :default do
        key :description, 'unexpected error'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end
  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
    gon.posts = @posts
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:name, :pubhlish, :location)
    end
end
