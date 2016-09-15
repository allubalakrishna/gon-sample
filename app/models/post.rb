class Post < ApplicationRecord
  validates :name, presence: true
	include Swagger::Blocks

  swagger_schema :Post do
    key :required, [:id, :name, :pubhlish]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end 
    property :pubhlish do
      key :type, :string
    end    
  end

  swagger_schema :PostInput do
    allOf do
      schema do
        key :'$ref', :Post
      end
      schema do
        key :required, [:name, :pubhlish]
        property :id do
          key :type, :integer
          key :format, :int64
        end
      end
    end
  end
end

