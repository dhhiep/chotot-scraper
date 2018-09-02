require 'HTTParty'
require 'Nokogiri'
require 'pry'

# Global variable
offset = 0
page = 1

puts "\e[33;49;1m = = = =  Chotot - Scraper script is starting  = = = = \e[0m"

while true
  url = "https://gateway.chotot.com/v1/public/ad-listing?region=13&cg=8000&w=1&limit=20&o=#{offset}&st=s,k&f=p&page=#{page}"
  list_item = HTTParty.get(url)['ads'] rescue nil
  break unless list_item
  puts "\e[33;49;1m - - - -  Analyzing page #{page}  - - - - \e[0m"

  list_item.each do |item|
    list_id = item['list_id']
    detail_page_url = "https://www.chotot.com/x/mua-ban-do-chuyen-dung-giong-nuoi-trong/#{ list_id }.htm"
    detail_response = HTTParty.get(detail_page_url)
    detail_response = Nokogiri::HTML(detail_response)

    area_name = item['area_name']
    account_id = item['account_id']
    account_name = item['account_name']
    phone_number = detail_response.document.to_s.scan(/"phone":"([0-9]*)"/).first.first

    puts "\e[33;49;1m Infomation: #{account_name} - #{phone_number} - #{area_name} \e[0m"
    sleep 0.5
  end

  offset += 20
  page += 1

  break if page == 3
end

puts "\e[33;49;1m = = = =  Chotot - Scraper script is end  = = = = \e[0m"
