# frozen_string_literal: true

class Print < ApplicationRecord
  belongs_to :printer
  belongs_to :uploaded_file
end
