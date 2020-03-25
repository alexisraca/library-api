class UserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :created_at, :updated_at, :email
end
