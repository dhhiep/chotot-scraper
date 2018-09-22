namespace :chotot do
  # rake chotot:scrape PAGE=0 RETRY=150 CATEGORY_ID=8000,13000 REGION_ID=12,13 AREA_ID=100,101
  task scrape: :environment do
    # Global variable
    page = ENV['PAGE'].present? ? ENV['PAGE'].to_i : 0
    max_retry = ENV['RETRY'].present? ? ENV['RETRY'].to_i : 150
    cagetory_ids = ENV['CATEGORY_ID'].present? ? ENV['CATEGORY_ID'].to_s.split(',').map(&:to_i) : all_cagetory_ids
    region_ids = ENV['REGION_ID'].present? ? ENV['REGION_ID'].to_s.split(',').map(&:to_i) : all_region_ids
    area_ids = ENV['AREA_ID'].present? ? ENV['AREA_ID'].to_s.split(',').map(&:to_i) : all_area_ids
    custom_msg = "Custom scraping Cagetory IDS #{cagetory_ids} - Region IDS #{region_ids} - area IDS #{area_ids}"

    Category.where(ct_category_id: cagetory_ids).each do |category|
      Region.where(region_id: region_ids).each do |region|
        region.areas.where(area_id: area_ids).each do |area|
          chottot_scraper(page, max_retry, category, region, area, custom_msg)
        end
      end
    end
  end


  # rake chotot:daily_scrape RETRY=150
  task daily_scrape: :environment do
    max_retry = ENV['RETRY'].present? ? ENV['RETRY'].to_i : 150

    Category.all.each do |category|
      Region.all.each do |region|
        region.areas.each do |area|
          chottot_scraper(0, max_retry, category, region, area)
        end
      end
    end
  end

  def chottot_scraper(page, max_retry, category, region = nil, area = nil, custom_msg = '')
    dup_counter = 0
    uuid = "%05d" % rand(1...99_999)
    offset = page * 20

    summary(uuid, category, dup_counter, offset, region, area, custom_msg, 'Chotot - Scraper script is starting')

    loop do
      base_url = 'https://gateway.chotot.com/v1/public/ad-listing?w=1&limit=20&st=s,k&f=p'
      url = "#{base_url}&region=#{region.id}&area=#{area.id}&cg=#{category.ct_category_id}&o=#{offset}&page=#{page}"
      list_item = HTTParty.get(url)['ads'] rescue nil
      if list_item.blank?
        summary(uuid, category, dup_counter, offset, region, area, custom_msg, "List end at page #{page}")
        return "List end at page #{page}"
        break
      end

      summary(uuid, category, dup_counter, offset, region, area, custom_msg, "Analyzing page #{page}", false)
      list_item.each do |item|
        account =
          Account.create_by_oid(
            item['account_oid'],
            {
              area_name: item['area_name'],
              region_id: region.region_id,
              area_id: area.area_id
            }
          )

        # Check and create list
        if List.by_lid(item['list_id'])
          # List item existed in DB, mean the account was created
          if dup_counter > max_retry
            summary(uuid, category, dup_counter, offset, region, area, custom_msg, "List Duplicated from page #{page}")
            return 'List Duplicated'
          else
            dup_counter += 1
          end
        elsif account
          List.create(
            list_id: item['list_id'],
            account: account,
            category: category,
            ad_id: item['ad_id'],
            category_name: item['category'],
            region_id: region.region_id,
            area_id: area.area_id,
            area_name: item['area_name']
          )
        end

        sleep 0.7
      end

      summary(uuid, category, dup_counter, offset, region, area, custom_msg, "page #{page}")

      page += 1
      offset = page * 20
    end

    summary(uuid, category, dup_counter, offset, region, area, custom_msg, 'Chotot - Scraper script is finished')
  end

  def summary(uuid, category, dup_counter, offset, region, area, custom_msg, prefix = '', store = true)
    parts = []
    parts << "#{custom_msg} #{prefix}".upcase
    parts << "Category: #{category.name} (#{category.ct_category_id})"
    parts << "Region: #{region.name} (#{region.region_id})"
    parts << "Area: #{area.name} (#{area.area_id})"
    parts << "Offset: #{offset}"
    parts << "Time: #{Time.now.in_time_zone('Asia/Ho_Chi_Minh').strftime('%d/%m/%Y %H:%M')}"
    # parts << "List: #{List.count}"
    parts << "Account: #{Account.count}"
    parts << "Duplicate: #{dup_counter}"
    text = parts.join(' | ')

    Summary.create(uuid: uuid, description: text) if store
    puts "\e[31;49;1m - - - RAKE ID: ##{uuid} - #{text} - - - \e[0m"
  end

  def all_cagetory_ids
    Category.pluck(:ct_category_id)
  end

  def all_region_ids
    Region.pluck(:region_id)
  end

  def all_area_ids
    Area.pluck(:area_id)
  end
end
