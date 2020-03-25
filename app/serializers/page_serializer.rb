class PageSerializer < ActiveModel::Serializer
  attributes :id, :book_id, :page_number, :created_at, :updated_at
end
