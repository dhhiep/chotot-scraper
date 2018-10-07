class Comment < ApplicationRecord
  belongs_to :potential

  def fulltext
    "#{content} --- #{created_at.to_display}"
  end
end
