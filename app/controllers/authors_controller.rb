class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]
  include Swagger::Blocks
  swagger_path '/authors/{id}' do
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
        key :description, 'Author response'
        schema do
          key :'$ref', :Author
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
        key :description, 'ID of Author to fetch'
        key :required, true
        key :type, :string
        key :format, :int64
      end
      parameter do
        key :name, :post
        key :in, :body
        key :description, 'Author to add to the store'
        key :required, true
        schema do
          key :'$ref', :AuthorInput
        end
      end
    end
    operation :delete do
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of Author to fetch'
        key :required, true
        key :type, :string
        key :format, :int64
      end
    end
  end
  swagger_path '/authors' do
    operation :get do
      key :description, 'Returns all Author from the system that the user has access to'
      key :operationId, 'findAuthors'
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
        key :description, 'Author response'
        schema do
          key :type, :array
          items do
            key :'$ref', :Author
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
      key :description, 'Creates a new author in the store.  Duplicates are allowed'
      key :operationId, 'addAuthor'
      key :produces, [
                       'application/json'
                   ]
      parameter do
        key :name, :post
        key :in, :body
        key :description, 'author to add to the store'
        key :required, true
        schema do
          key :'$ref', :AuthorInput
        end
      end
      response 200 do
        key :description, 'author response'
        schema do
          key :'$ref', :Author
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
  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.all
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
  end

  # GET /authors/new
  def new
    @my_var = []
    5.times do |index|
      @my_var << Author.new
    end    
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors
  # POST /authors.json
  def create
    @errors = {}
    @my_var = []         
    params[:authors].keys.each do |key|      
      @author = Author.create(author_params(params[:authors][key]))
      if @author.errors.full_messages.present?
         @errors[key] = @author.errors.full_messages
      else
         params[:authors].delete(key)
      end
    end
    if @errors.present?
      @errors.keys.each do |index|        
        @my_var << Author.new(author_params(params[:authors][index]))
      end
      render 'new', alert: @errors
    else
      redirect_to authors_path
    end
  end

  # PATCH/PUT /authors/1
  # PATCH/PUT /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to @author, notice: 'Author was successfully updated.' }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    @author.destroy
    respond_to do |format|
      format.html { redirect_to authors_url, notice: 'Author was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params(my_params)      
      my_params.permit(:name, :country, :gender)
    end
end