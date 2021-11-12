require "rubygems"
require "nokogiri"
require "csv"

registration_numbers_file_name = "registration_numbers.csv"

supplier_registration_numbers = {}
customer_registration_numbers = {}
customer_identification_numbers = {}
column_index = {}

source_file_name = "results.csv"
CSV.foreach(source_file_name, encoding: "UTF-8") do |row|
  if row[0] == 'pvs_number'
    column_index = Hash[row.map.with_index.map{|c, i| [c,i]}]
    next
  end

  supplier_registration_number = row[column_index['supplier_registration_number']]
  supplier_name = row[column_index['supplier_name']]
  if supplier_registration_number && supplier_registration_number.length >= 6
    supplier_registration_numbers[supplier_registration_number] ||= {}
    supplier_registration_numbers[supplier_registration_number][supplier_name] ||= 0
    supplier_registration_numbers[supplier_registration_number][supplier_name] += 1
  end

  customer_registration_number = row[column_index['customer_registration_number']]
  customer_name = row[column_index['customer_name']]
  if customer_registration_number && customer_registration_number.length >= 6
    customer_registration_numbers[customer_registration_number] ||= {}
    customer_registration_numbers[customer_registration_number][customer_name] ||= 0
    customer_registration_numbers[customer_registration_number][customer_name] += 1
  end

  identification_number = row[column_index['identification_number']]
  pvs_number = row[column_index['pvs_number']]
  if customer_registration_number && identification_number
    pvs_numbers = (customer_identification_numbers[[customer_registration_number, identification_number]] ||= [])
    pvs_numbers << pvs_number unless pvs_numbers.include? pvs_number
  end
end

File.open("registration_numbers.csv", "w") do |file|
  supplier_registration_numbers.each do |number, names|
    most_used_name = names.to_a.sort_by{|name, count| -count}.first.first
    file.puts [number, most_used_name].to_csv
  end
end

File.open("customer_registration_numbers.csv", "w") do |file|
  customer_registration_numbers.each do |number, names|
    next if names.keys.length <= 1
    most_used_name = names.to_a.sort_by{|name, count| -count}.first.first
    file.puts [number, most_used_name].to_csv
  end
end

File.open("replaced_pvs_numbers.csv", "w") do |file|
  customer_identification_numbers.each do |customer_and_identification, pvs_numbers|
    customer_registration_number, identification_number = customer_and_identification
    pvs_numbers[0..-2].each do |replaced_pvs_number|
      file.puts [replaced_pvs_number, customer_registration_number, identification_number].to_csv
    end
  end
end
