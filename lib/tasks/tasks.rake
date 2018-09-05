namespace :tasks do
  task update_category_names: :environment do
    Account.find_in_batches do |accounts|
      accounts.each do |account|
        p "Processing #{account.id} ..."
        next if account.category_names.present?
        account.build_category_names!
        account.save
      end
    end
  end
end