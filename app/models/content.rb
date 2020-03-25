class Content < ApplicationRecord
  belongs_to :page
  belongs_to :content_format

  validates :content_format, presence: true
  validates :page, presence: true

  # TODO install carrierwave or paperclip to manage file upload
end
