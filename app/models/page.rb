class Page < ApplicationRecord
  belongs_to :book
  has_many :contents

  acts_as_sequenced column: :page_number, scope: :book_id
end
