class Author < ApplicationRecord
  validates :name, :country, presence: true
  # enum gender: [:male, :female, :others]
  include Swagger::Blocks
  swagger_schema :Author do
    key :required, [:id, :name]
    property :name do
      key :type, :string
    end
    property :country do
      key :type, :string
    end
    property :gender do
      key :type, :string
    end
  end

  swagger_schema :AuthorInput do
    allOf do
      schema do
        key :'$ref', :Author
      end
      schema do
        key :required, [:name]
      end
    end
  end
end