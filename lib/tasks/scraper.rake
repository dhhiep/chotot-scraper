namespace :chotot do
  # rake chotot:scrape PAGE=1 RETRY=4
  task scrape: :environment do
    # Global variable
    dup_counter = 0
    uuid = "%05d" % rand(1...99_999)
    page = ENV['PAGE'] ? ENV['PAGE'].to_i : 1
    max_retry = ENV['RETRY'] ? ENV['RETRY'].to_i : 1
    summary(uuid, 'Chotot - Scraper script is starting')

    loop do
      url = "https://gateway.chotot.com/v1/public/ad-listing?region=13&cg=8000&w=1&limit=20&st=s,k&f=p&o=#{page * 20}&page=#{page}"
      list_item = HTTParty.get(url)['ads'] rescue nil
      if list_item.blank?
        summary(uuid, "List end at page #{page}")
        abort "List end at page #{page}"
        break
      end
      
      summary(uuid, "Analyzing page #{page}", false)
      list_item.each do |item|
        list_id = item['list_id']
        if List.by_lid(list_id)
          # List item existed in DB, mean the account was created
          if dup_counter > max_retry
            summary(uuid, "List Duplicated from page #{page}")
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
              category: Category.first_or_create,
              ad_id: item['ad_id'],
              category_name: item['category'],
              area_name: item['area_name']
            )
          end
        end

        sleep 0.7 
      end

      summary(uuid, "page #{page}")

      page += 1
    end

    summary(uuid, 'Chotot - Scraper script is finished')
  end

  def summary(uuid, prefix = '', store = true)
    parts = []
    parts << prefix.upcase
    parts << "Time: #{Time.now}"
    parts << "Category: #{Category.count}"
    parts << "List: #{List.count}"
    parts << "Account: #{Account.count}"
    text = parts.join(' | ')

    Summary.create(uuid: uuid, description: text) if store
    puts "\e[31;49;1m - - - RAKE ID: ##{uuid} - #{text} - - - \e[0m"
  end
end
