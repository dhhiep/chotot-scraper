namespace :chotot do
  # rake chotot:scrape PAGE=1 RETRY=4 CATEGORY_ID=5000
  task scrape: :environment do
    # Global variable
    page = ENV['PAGE'].present? ? ENV['PAGE'].to_i : 0
    max_retry = ENV['RETRY'].present? ? ENV['RETRY'].to_i : 50
    category_id = ENV['CATEGORY_ID'].present? ? ENV['CATEGORY_ID'].to_i : 5000

    chottot_scraper(page, max_retry, category_id)
  end

  task daily_scrape: :environment do
    Category.all.each do |category|
      chottot_scraper(0, 150, category.ct_category_id)
    end
  end

  def chottot_scraper(page, max_retry, category_id, region = 13)
    dup_counter = 0
    uuid = "%05d" % rand(1...99_999)
    offset = page * 20
    category = Category.where(ct_category_id: category_id).first_or_create
    summary(uuid, category, dup_counter, offset, 'Chotot - Scraper script is starting')

    loop do
      base_url = 'https://gateway.chotot.com/v1/public/ad-listing?w=1&limit=20&st=s,k&f=p'
      url = "#{base_url}&region=#{region}&cg=#{category_id}&o=#{offset}&page=#{page}"
      list_item = HTTParty.get(url)['ads'] rescue nil
      if list_item.blank?
        summary(uuid, category, dup_counter, offset, "List end at page #{page}")
        return "List end at page #{page}"
        break
      end

      summary(uuid, category, dup_counter, offset, "Analyzing page #{page}", false)
      list_item.each do |item|
        list_id = item['list_id']
        account = Account.create_by_oid(item['account_oid'], { area_name: item['area_name'] })

        # Check and create list
        if List.by_lid(list_id)
          # List item existed in DB, mean the account was created
          if dup_counter > max_retry
            summary(uuid, category, dup_counter, offset, "List Duplicated from page #{page}")
            return 'List Duplicated'
          else
            dup_counter += 1
          end
        elsif account
          List.create(
            list_id: list_id,
            account: account,
            category: category,
            ad_id: item['ad_id'],
            category_name: item['category'],
            area_name: item['area_name']
          )
        end

        sleep 0.7
      end

      summary(uuid, category, dup_counter, offset, "page #{page}")

      page += 1
      offset = page * 20
    end

    summary(uuid, category, dup_counter, offset, 'Chotot - Scraper script is finished')
  end

  def summary(uuid, category, dup_counter, offset, prefix = '', store = true)
    parts = []
    parts << prefix.upcase
    parts << "Category: #{category.name} (#{category.ct_category_id})"
    parts << "Offset: #{offset}"
    parts << "Time: #{Time.now.in_time_zone('Asia/Ho_Chi_Minh').strftime('%d/%m/%Y %H:%M')}"
    # parts << "List: #{List.count}"
    parts << "Account: #{Account.count}"
    parts << "Duplicate: #{dup_counter}"
    text = parts.join(' | ')

    Summary.create(uuid: uuid, description: text) if store
    puts "\e[31;49;1m - - - RAKE ID: ##{uuid} - #{text} - - - \e[0m"
  end
end
