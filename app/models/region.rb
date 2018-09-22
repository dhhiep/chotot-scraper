class Region < ApplicationRecord
  has_many :areas, primary_key: :region_id
  has_many :accounts, primary_key: :region_id
end
