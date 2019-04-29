# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

hugo = Client.create!(name: "Hugo da Silva", cpf: "351.116.040-57", email: "hugo.silva@gmail.com")
laura = Client.create!(name: "Laura Castelo", cpf: "704.543.630-01", email: "laura2299@hotmail.com")

hugo.subscriptions.create!(phone_model: "Samsung S9 Plus", imei: "545224863866610", full_price: 399.90, payments: 12)
laura.subscriptions.create!([
    {phone_model: "Motorola G6 Plus", imei: "352430624834761", full_price: 299.90, payments: 6},
    {phone_model: "Motorola G7 Power", imei: "102582642555258", full_price: 499.90, payments: 12}
])
