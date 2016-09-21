require 'csv'

PublicBody.update_all(id_gov: -1)

CSV.foreach('completo.csv', :headers => true, :col_sep => ";") do |row|
  r = row.to_hash
  print "Updating #{r['name']} .... "
  pb = PublicBody.where(name: r['name'].to_s).first
  if pb != nil
    pb.id_gov = r['id'].to_i
    pb.save!
    puts "Gooood"
  else
    puts "Not found"
  end

end