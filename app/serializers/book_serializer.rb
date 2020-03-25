class BookSerializer < ActiveModel::Serializer
  attributes :name, :created_at, :updated_at
end
