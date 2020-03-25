class ContentSerializer < ActiveModel::Serializer
  attributes :id, :body, :page_id, :content_format_id, :file
end
