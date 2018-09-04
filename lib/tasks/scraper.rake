namespace :chotot do
  # rake chotot:scrape PAGE=1 RETRY=4
  task scrape: :environment do
    # Global variable
    dup_counter = 0
    uuid = "%05d" % rand(1...99_999)
    page = ENV['PAGE'] ? ENV['PAGE'].to_i : 0
    offset = page * 20
    max_retry = ENV['RETRY'] ? ENV['RETRY'].to_i : 10
    category_id = '5000'
    category = Category.where(name: category_id).first_or_create
    summary(uuid, category, dup_counter, offset, 'Chotot - Scraper script is starting')

    loop do
      base_url = 'https://gateway.chotot.com/v1/public/ad-listing?region=13&w=1&limit=20&st=s,k&f=p'
      url = "#{base_url}&cg=#{category_id}&o=#{offset}&page=#{page}"
      list_item = HTTParty.get(url)['ads'] rescue nil
      if list_item.blank?
        summary(uuid, category, dup_counter, offset, "List end at page #{page}")
        abort "List end at page #{page}"
        break
      end

      summary(uuid, category, dup_counter, offset, "Analyzing page #{page}", false)
      list_item.each do |item|
        list_id = item['list_id']
        if List.by_lid(list_id)
          # List item existed in DB, mean the account was created
          if dup_counter > max_retry
            summary(uuid, category, dup_counter, offset, "List Duplicated from page #{page}")
            abort 'List Duplicated'
          else
            dup_counter += 1
          end
        else
          account = Account.create_by_oid(item['account_oid'])
          if account
            List.create(
              list_id: list_id,
              account: account,
              category: category,
              ad_id: item['ad_id'],
              category_name: item['category'],
              area_name: item['area_name']
            )
          end
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
    parts << "Category: #{category.name}"
    parts << "Offset: #{offset}"
    parts << "Time: #{Time.now.in_time_zone('Asia/Ho_Chi_Minh').strftime("%d/%m/%Y %H:%M")}"
    parts << "List: #{List.count}"
    parts << "Account: #{Account.count}"
    parts << "Duplicate: #{dup_counter}"
    text = parts.join(' | ')

    Summary.create(uuid: uuid, description: text) if store
    puts "\e[31;49;1m - - - RAKE ID: ##{uuid} - #{text} - - - \e[0m"
  end
end
