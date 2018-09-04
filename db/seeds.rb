# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

emails = [
  'trang.qk@hiep.com',
  'hoanghiepitvnn@gmail.com'
]

emails.each do |email|
  user = User.where(email: email).first_or_initialize
  user.update(password: '123456')
end

categories = {
  1000 => 'Bất động sản',
  2000 => 'Xe cộ',
  3000 => 'Thời trang, đồ cá nhân',
  4000 => 'Giải trí, thể thao, sở thích',
  5000 => 'Đồ Điện tử',
  6000 => 'Dịch vụ và du lịch',
  7000 => 'Các loại khác',
  8000 => 'Đồ Văn phòng, Công nông nghiệp',
  9000 => 'Nội ngoại thất, đồ gia dụng',
  11_000 => 'Mẹ và Bé',
  12_000 => 'Thú cưng',
  13_000 => 'Việc làm'
}

%w[5000 8000 9000 1000].each do |id_existed|
  category = Category.find_by_name(id_existed)
  next unless category
  cateogry_name = categories[id_existed.to_i]
  category.update(name: cateogry_name, ct_category_id: id_existed.to_i)
end

categories.each do |k, v|
  Category.where(ct_category_id: k).first_or_create(name: v)
end
