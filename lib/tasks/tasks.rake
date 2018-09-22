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
end
