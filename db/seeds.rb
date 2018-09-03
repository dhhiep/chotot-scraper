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
