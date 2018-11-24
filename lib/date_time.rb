Date.class_eval do
  def to_datepicker_format
    strftime("%d/%m/%Y")
  end

  def to_datetimepicker_format
    in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y %I:%M %p")
  end
  
  def to_display_date
    in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y")
  end

  def to_display_datetime
    in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y %I:%M %p")
  end

  def add_time(time)
    change({ hour: time.hour, min: time.min })
  end
end

ActiveSupport::TimeWithZone.class_eval do
  def to_datepicker_format
    strftime("%d/%m/%Y")
  end

  def to_display
    strftime("%d/%m/%Y %I:%M %p")
  end

  def to_display_date
    in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y")
  end

  def to_display_datetime
    in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y %I:%M %p")
  end
end

ActiveSupport::TimeZone.class_eval do
  def strptime(str, fmt, now = self.now)
    date_parts = Date._strptime(str, fmt)
    return if date_parts.blank?
    time = Time.strptime(str, fmt, now) rescue DateTime.strptime(str, fmt, now)
    if date_parts[:offset].nil?
      ActiveSupport::TimeWithZone.new(nil, self, time)
    else
      time.in_time_zone(self)
    end
  end
end
