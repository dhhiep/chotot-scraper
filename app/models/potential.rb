class Potential < ApplicationRecord
  belongs_to :account, optional: true
  has_many :comments

  accepts_nested_attributes_for :comments, :allow_destroy => true

  OWNER ||= %w[Trang Hiệp]


  def last_comment
    comments.order(:created_at).last
  end

  def self.sort_by_remind_date
    all.reorder("
      CASE WHEN remind_at > NOW() THEN 1
           WHEN remind_at < NOW() THEN 2
      END ASC
    ")
  end

  def remind_at_field
    remind_at.present? ? remind_at.to_display : ''
  end

  def remind_at_field=(string)
    self.remind_at = string.to_date_picker
  end
end
