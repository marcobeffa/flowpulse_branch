puts "Seeding base data..."

# Utente admin
user = User.find_or_create_by!(email_address: "markpostura@gmail.com") do |u|
  u.password = "password123"
  u.admin = true
end
