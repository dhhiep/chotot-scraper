class Account < ApplicationRecord
  has_many :lists
  has_one :zalo

  enum status: { status_new: 0, status_inserted: 1 }
  enum wse_status: { wse_unknown: 0, wse_valid: 1, wse_duplicate: 2, wse_invalid: 3 }

  scope :address_present, -> { where.not(address: nil).where.not(address: '') }
  scope :address_min_length, -> (length) { where("length(accounts.address) >= ?", length) }
  scope :active, -> { address_present.includes(:zalo).where(hide: false) }
  scope :wse_unknown, -> { active.find_wse_status(:wse_unknown) }
  scope :wse_valid, -> { active.find_wse_status(:wse_valid) }
  scope :wse_duplicate, -> { active.find_wse_status(:wse_duplicate) }
  scope :wse_invalid, -> { active.find_wse_status(:wse_invalid) }
  scope :find_wse_status, ->(sts) { where(wse_status: sts) }
  scope :favorites, -> { where(favorite: true) }
  scope :in_district, ->(area_name) { where(area_name: area_name) }
  scope :only_hcm, -> { where(region_id: 13) }

  def self.by_oid(oid)
    find_by_account_oid(oid)
  end

  def self.today_summary
    summary_rows = {}
    today = by_range(from: Time.current.beginning_of_day, to: Time.current.end_of_day)
    summary_rows.merge!(summary_text('Last 2 hours:', by_range(from: 2.hours.ago)))
    summary_rows.merge!(summary_text('Today', today))
  end

  def self.summary_text(text, resources)
    total = resources.count
    wse_dup = resources.wse_duplicate.count
    wse_inv = resources.wse_invalid.count
    {"#{ text } (Check/Inserted/Dup/Invalid):": "#{ total }/#{ total - wse_dup - wse_inv }/#{ wse_dup }/#{ wse_inv }"}
  end

  def self.by_range(from: nil, to: nil, wse_status: nil)
    resources = active
    case wse_status
    when :valid
      resources.wse_valid
    when :unknown
      resources.wse_unknown
    when :valid
      resources.wse_valid
    when :duplicate
      resources.wse_duplicate
    end

    resources = resources.where('inserted_at >= :from', from: from) if from
    resources = resources.where('inserted_at <= :to', to: to) if to
    resources
  end

  def self.create_by_oid(oid, extra = {})
    account = by_oid(oid)
    return if account
    response = load_account_from_chotot(oid)
    return false unless response['account_id']
    response['region_id'] = extra[:region_id]
    response['area_id'] = extra[:area_id]
    response['area_name'] = extra[:area_name]
    location = response['location']
    if location
      response['lat'] = response['location'][0]
      response['lng'] = response['location'][1]
      response.delete('location')
    end
    where(account_id: response['account_id']).first_or_create(response.as_json(only: whitelist_params))
  end

  def self.districts
    @districts ||= Region.find_by_region_id(13).areas.pluck(:name)
  end

  def self.load_account_from_chotot(oid)
    url = "https://gateway.chotot.com/v1/public/profile/#{oid}"
    HTTParty.get(url)
  end

  def fetch_zalo_info!
    return if zalo
    begin
      data = HTTParty.get("https://own-phone-number-detector.herokuapp.com/#{phone}/phone-finder")
      create_zalo(
        name: data['name'],
        avatar: data['avatar'],
        gender: data['gender'],
        birthday: data['birth_day']
      )
    rescue Exception => e
    end
  end

  def address_filtered
    return '' if address.blank?
    address_tmp = address
    keywords = [
      ', Tp.HCM', ', Việt Nam', ', HCM', ', Hồ Chí Minh', 'tp ho chi minh', ', Vietnam', ', TpHCM', 'tphcm', 'hcm',
      ', tp. HCM', ', tphcm'
    ]
    keywords.each do |keyword|
      address_tmp = address_tmp.gsub(keyword, '')
    end
    address_tmp
  end

  def chotot_updated_at
    update_time.to_s.unix_to_time.to_display_date rescue nil
  end

  def chotot_created_at
    create_time.to_s.unix_to_time.to_display_date rescue nil
  end

  def build_category_names!
    self.category_names = lists.includes(:category).map { |l| l.category.try(:name) }.reject(&:blank?).join(', ')
  end

  def hide!
    update(hide: true)
  end

  def toggle_favorite!
    update(favorite: !favorite)
  end

  def self.whitelist_params
    %w[
      account_id account_oid address create_time deviation email email_verified
      avatar facebook_id facebook_token full_name lat lng long_term_facebook_token
      phone phone_verified start_time update_time is_active area_name region_id
      area_id
    ]
  end
end
