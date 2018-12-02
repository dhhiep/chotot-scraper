namespace :tasks do
  task update_category_names: :environment do
    Account.find_in_batches do |accounts|
      accounts.each do |account|
        p "Update Category Name processing #{account.id} ..."
        next if account.category_names.present?
        account.build_category_names!
        account.save
      end
    end
  end

  task update_area_names: :environment do
    # Account.find_in_batches do |accounts|
    #   accounts.each do |account|
    #     p "Update Area Name processing #{account.id} ..."
    #     next if account.area_name.present?
    #     area_name = account.lists.first.try(:area_name)
    #     next if area_name.blank?
    #     account.update(area_name: area_name)
    #   end
    # end
  end

  task update_all_account_to_region_13: :environment do
    Account.update_all(region_id: 13)
  end

  task create_regions_areas: :environment do
    regions_and_areas = YAML.safe_load(File.read('config/regions_and_areas.yml'))
    regions_and_areas.each do |region_id, region_data|
      Region.where(region_id: region_id).first_or_create(name: region_data['name'])
      region_data['area'].each do |area_id, area_data|
        Area.where(area_id: area_id, region_id: region_id).first_or_create(name: area_data['name'])
      end
    end
  end

  task fix_area_id_from_area_name_for_accounts: :environment do
    area_names = Account.pluck(:area_name).uniq.compact
    area_names.each do |area_name|
      area = Area.find_by_name(area_name)
      next unless area
      Account.where(area_name: area_name).update_all(area_id: area.id)
    end
  end

  # rake tasks:migrate_list_to_account FROM_ROW=0 to TO_ROW=5
  task migrate_list_to_account: :environment do
    row_number = 0
    total      = List.count
    from_row   = ENV['FROM_ROW'].present? ? ENV['FROM_ROW'].to_i : 1
    to_row     = ENV['TO_ROW'].present? ? ENV['TO_ROW'].to_i : nil

    List.includes(:account).find_in_batches do |list|
      list.each do |list_item|
        row_number += 1 # row data
        next if row_number < from_row
        abort if to_row && row_number > to_row

        if account = list_item.account
          account.list_id = list_item.list_id
          account.category_id = list_item.category_id
          account.ad_id = list_item.ad_id
          account.category_code = list_item.category_name
          account.save
        end

        puts "Updated on Account ##{account.try(:id)} (#{row_number}/#{total})"
      end
    end
  end
end
