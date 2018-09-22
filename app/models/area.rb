class Area < ApplicationRecord
  belongs_to :region, foreign_key: :region_id
  has_many :accounts, primary_key: :area_id
end
