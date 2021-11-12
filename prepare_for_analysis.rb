# encoding: utf-8
require "csv"

CPV = {}

cpv_file_name = "cpv_all.csv"
CSV.foreach(cpv_file_name, encoding: "UTF-8") do |row|
  code, lv, en, _ = row
  next if code == 'Kods'

  key = code.split('-').first
  # Remove trailing dots
  lv = lv.strip.gsub(/\.\z/, '')
  CPV[key] = {code: code, name: lv}
end
INVALID_CPV_CODES = []

REGISTRATION_NUMBERS = {}
registration_numbers_file_name = "registration_numbers.csv"
CSV.foreach(registration_numbers_file_name, encoding: "UTF-8") do |row|
  number, name = row
  REGISTRATION_NUMBERS[number] = name
end

CUSTOMER_REGISTRATION_NUMBERS = {}
customer_registration_numbers_file_name = "customer_registration_numbers.csv"
CSV.foreach(customer_registration_numbers_file_name, encoding: "UTF-8") do |row|
  number, name = row
  CUSTOMER_REGISTRATION_NUMBERS[number] = name
end

REPLACED_PVS_NUMBERS = {}
replaced_pvs_numbers_file_name = "replaced_pvs_numbers.csv"
CSV.foreach(replaced_pvs_numbers_file_name, encoding: "UTF-8") do |row|
  pvs_number, customer_registration_number, identification_number = row
  REPLACED_PVS_NUMBERS[pvs_number] = true
end

puts [
  :result_type, :result_date,
  :customer, :contact, :customer_country, :customer_city_or_region,
  :cpv_code, :proposals_count, :contracts_count,
  :supplier, :amount, :currency, :amount_eur
].to_csv

column_index = {}

source_file_name = ARGV[0] || 'results.csv'
CSV.foreach(source_file_name, encoding: "UTF-8") do |row|
  if row[0] == 'pvs_number'
    column_index = Hash[row.map.with_index.map{|c, i| [c.to_sym,i]}]
    next
  else
    attributes = {}
    column_index.each{|key, index| attributes[key] = row[column_index[key]]}
  end

  pvs_number = attributes[:pvs_number]
  next if REPLACED_PVS_NUMBERS[pvs_number]

  result_type = case attributes[:title]
  when /iepirkuma/i then 'Iepirkuma rezultāts'
  when /noslēgto/i then 'Noslēgts līgums'
  else 'Cits'
  end

  result_date = attributes[:decision_date] || attributes[:published_date]

  customer_registration_number = attributes[:customer_registration_number]
  customer = CUSTOMER_REGISTRATION_NUMBERS[customer_registration_number] || attributes[:customer_name]
  customer += " (#{customer_registration_number})" if customer_registration_number

  contact = attributes[:contact_person]
  if contact_email = attributes[:contact_email]
    contact << " (#{contact_email})"
  end

  cpv_code = attributes[:cpv_code]
  cpv_key = cpv_code.split('-').first[0,8]
  unless CPV[cpv_key]
    cpv_key = cpv_key + '0'*(8-cpv_key.length) if cpv_key.length < 8
  end
  if CPV[cpv_key]
    cpv_code = CPV[cpv_key][:code]
    CPV[cpv_key][:used] ||= 0
    CPV[cpv_key][:used] += 1
  else
    # STDERR.puts "ERROR: #{pvs_number} missing CPV key #{cpv_key}" unless CPV[cpv_key]
    INVALID_CPV_CODES << cpv_code
  end

  supplier_registration_number = attributes[:supplier_registration_number]
  supplier = REGISTRATION_NUMBERS[supplier_registration_number] || attributes[:supplier_name]
  supplier += " (#{supplier_registration_number})" if supplier_registration_number

  amount = attributes[:contract_amount] || attributes[:proposed_amount]
  currency = attributes[:contract_currency] || attributes[:proposed_currency]
  amount_eur = attributes[:contract_amount_eur]

  next if amount.nil? || amount == '0' || amount == '0.0'
  raise "PVS number #{pvs_number} missing EUR amount" if amount_eur.nil? || amount_eur == '0' || amount_eur == '0.0'

  puts [
    result_type, result_date,
    customer, contact, attributes[:customer_country], attributes[:customer_city_or_region],
    cpv_code, attributes[:proposals_count], 1,
    supplier, amount, currency, amount_eur
  ].to_csv
end

cpv_codes_file = File.open("cpv_codes.csv", "w", encoding: "UTF-8")
cpv_codes_file.puts [:cpv_1, :cpv_2, :cpv_code, :cpv_used].to_csv
CPV.each do |key, cpv|
  next unless cpv[:used]
  code = cpv[:code]
  cpv_1 = CPV[code[0,2]+'000000']
  cpv_2 = CPV[code[0,3]+'00000']
  cpv_codes_file.puts [
    "#{cpv_1[:code][0,2]} #{cpv_1[:name]}",
    "#{cpv_2[:code][0,3]} #{cpv_2[:name]}",
    cpv[:code],
    cpv[:used]
  ].to_csv
end
INVALID_CPV_CODES.uniq.each do |code|
  cpv_codes_file.puts ['Nepareizs', 'Nepareizs', code, INVALID_CPV_CODES.count{|c| c==code}].to_csv
end
cpv_codes_file.close
