class Print < ApplicationRecord
  has_one :printer
  has_one :uploaded_file
end
