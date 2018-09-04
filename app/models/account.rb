class Account < ApplicationRecord
  has_many :lists

  enum status: { status_new: 0, status_inserted: 1 }
  enum wse_status: { wse_unknown: 0, wse_valid: 1, wse_duplicate: 2, wse_invalid: 3 }

  scope :active, -> { where(hide: false) }

  def self.by_oid(oid)
    find_by_account_oid(oid)
  end

  def self.create_by_oid(oid)
    account = by_oid(oid)
    return if account
    response = load_account_from_chotot(oid)
    return false unless response['account_id']
    location = response['location']
    if location
      response['lat'] = response['location'][0]
      response['lng'] = response['location'][1]
      response.delete('location')
    end

    where(account_id: response['account_id']).first_or_create(response.as_json(only: whitelist_params))
  end

  def self.load_account_from_chotot(oid)
    url = "https://gateway.chotot.com/v1/public/profile/#{oid}"
    HTTParty.get(url)
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
  def hide!
    update(hide: true)
  end

  private

  def self.whitelist_params
    %w[
      account_id account_oid address create_time deviation email email_verified
      avatar facebook_id facebook_token full_name lat lng long_term_facebook_token
      phone phone_verified start_time update_time is_active
    ]
  end
end
