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
    Account.find_in_batches do |accounts|
      accounts.each do |account|
        p "Update Area Name processing #{account.id} ..."
        next if account.area_name.present?
        area_name = account.lists.first.try(:area_name)
        next if area_name.blank?
        account.update(area_name: area_name)
      end
    end
  end

  task update_all_account_to_region_13: :environment do
    Account.update_all(region_id: 13)
  end
end
