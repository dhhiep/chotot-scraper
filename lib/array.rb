Array.class_eval do
  def to_string(separator = ' ')
    self.reject(&:blank?).map(&:squish).join(separator)
  end
end
