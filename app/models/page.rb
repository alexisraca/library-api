class Page < ApplicationRecord
  belongs_to :book

  acts_as_sequenced column: :page_number, scope: :book_id
end
