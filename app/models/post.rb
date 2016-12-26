class Post < ApplicationRecord
  validates :name, presence: true
  include Swagger::Blocks

  swagger_schema :Post do
    key :required, [:id, :name]
    property :name do
      key :type, :string
    end
    property :pubhlish do
      key :type, :boolean
    end
    property :location do
      key :type, :string
    end
  end

  swagger_schema :PostInput do
    allOf do
      schema do
        key :'$ref', :Post
      end
      schema do
        key :required, [:name]
      end
    end
  end

  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  def slug_candidates
    [
      :title,
      [:title, :id]
    ]
  end

  after_create_commit :welcome_message
  after_update_commit :update_message
  after_destroy_commit :destroy_message

  def welcome_message
    puts "Welcome #{name}!!"
  end 

  def update_message
    puts "#{name} updated!!"
  end

  def destroy_message
    puts "#{name} destroyed!!"
  end
  # before_save :add_slug

  # def add_slug
  #   self.slug = name.parameterize
  # end

  # def to_param
  #   name.parameterize
  # end
end