String.class_eval do
  def numeric_only
    gsub(/\D/, "")
  end

  def unix_to_time
    DateTime.strptime(self, '%s')
  end

  def to_date_range
    split(" - ").map(&:to_date_picker)
  end

  def to_date_picker
    Time.zone.strptime(self, "%d/%m/%Y").try(:to_datetime)
  end

  def to_datetime_picker
    Time.zone.strptime(self, "%d/%m/%Y %I:%M %p").try(:to_datetime)
  end

  def to_qt_boolean
    self == '1'
  end

  def to_qt_boolean_text
    self == '1' ? 'Yes' : 'No'
  end
end
