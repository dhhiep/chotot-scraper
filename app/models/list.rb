class List < ApplicationRecord
  belongs_to :account
  belongs_to :category

  def self.by_lid(lid)
    find_by_list_id(lid)
  end

  def cho_tot_url
    "https://www.chotot.com/x/x/#{list_id}.htm"
  end
end
