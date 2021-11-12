# encoding: utf-8
require "rubygems"
require "nokogiri"
require "csv"
require "pry"

require_relative "classificators"

$error_count = 0

class SourceFile
  include Classificators

  def initialize(file_name)
    @file_name = file_name
    @body = File.read @file_name
    @doc = Nokogiri::XML @body

    @type = get_string document, '> type'
  end

  def results
    case @type
    when 'notice_concluded_contract',
          'notice_contract_rights', 'notice_contract_rights_sps',
          'notice_exante', 'sps_notice_exante'
      get_common_attributes
      get_customer_attributes
      results_from_contracts
    else
      []
    end
  rescue => e
    $stderr.puts "\n*** results: file_name=#{@file_name}"
    $stderr.puts "#{e.class.name}: #{e.message}"
    $stderr.puts e.backtrace[0..10].join("\n")
    $error_count += 1
    []
  end

  def get_common_attributes
    @pvs_number = get_integer document, '> id'
    @title = TYPE_TO_TITLE[@type]
    @published_date = get_date document, '> publication_date'
    @cpv_code = get_string general, '> main_cpv code'

    @total_amount = get_decimal document, '> price_exact'
    @total_currency = CURRENCIES[get_integer document, '> currency']
    @total_amount_eur = get_decimal document, '> price_exact_eur'

    @identification_number = strip_multiple_spaces get_string general, '> procurement_code'
  end

  def results_from_contracts
    document.css('part_5_list part_5').map do |contract|
      @contract_number = get_integer contract, '> contract_nr'
      @contract_title = get_string contract, '> concluded_contract_name'
      @decision_date = get_date contract, '> decision_date'
      @proposals_count = get_integer contract, '> tender_num'
      @supplier_name = get_string contract, 'winner_name'
      @supplier_registration_number = strip_spaces get_string contract, 'winner_reg_num'
      @supplier_city_or_region = get_string contract, 'winner_city'
      @supplier_country = COUNTRIES[get_integer contract, 'winner_country']

      @proposed_amount = get_decimal contract, '> initial_price'
      @proposed_currency = CURRENCIES[get_integer contract, '> initial_currency']
      @contract_amount = get_decimal(contract, '> contract_price_exact') || @proposed_amount
      @contract_currency = CURRENCIES[get_integer contract, '> exact_currency'] || @proposed_currency

      @contract_amount_eur = if @contract_currency == 'EUR'
        @contract_amount
      elsif @contract_currency == @total_currency && @total_amount && @total_amount_eur && @contract_amount
        (@contract_amount / @total_amount * @total_amount_eur).round(2)
      elsif @contract_currency == 'LVL' && @contract_amount
        (@contract_amount * 0.702804).round(2)
      elsif contract_price_exact_lvl = get_decimal(contract, '> contract_price_exact_lvl')
        (contract_price_exact_lvl * 0.702804).round(2)
      end
      result_attributes
    end.compact
  end

  def self.results_header
    [
      :pvs_number, :title, :published_date,
      :customer_name, :customer_registration_number,
      :customer_country, :customer_city_or_region,
      :contact_person, :contact_email,
      :cpv_code,
      :total_amount, :total_currency, :total_amount_eur,
      :identification_number,
      :contract_number, :contract_title, :decision_date, :proposals_count,
      :supplier_name, :supplier_registration_number,
      :supplier_country, :supplier_city_or_region,
      :proposed_amount, :proposed_currency, :contract_amount, :contract_currency, :contract_amount_eur
    ]
  end

  class_eval <<-RUBY
    def result_attributes
      [
        #{results_header.map{|name| "@#{name}"}.join(', ')}
      ]
    end
  RUBY

  private

  def document
    @document ||= @doc.at_css("document")
  end

  def general
    @general ||= document.at_css("general")
  end

  def get_customer_attributes
    @customer_name = get_string general, '> authority_name'
    @customer_registration_number = strip_spaces get_string general, '> authority_reg_num'
    @customer_city_or_region = get_string general, '> city'
    @customer_country = COUNTRIES[get_integer general, '> country']
    @contact_person = get_string document, 'contactplace > person'
    @contact_email = get_string document, 'contactplace > email'
  end

  def get_string(parent, selector)
    if el = parent.at_css(selector)
      el.text
    end
  end

  def get_integer(parent, selector)
    if (string = get_string(parent, selector)) && !string.empty?
      string.to_i
    end
  end

  def get_decimal(parent, selector)
    if (string = get_string(parent, selector)) && !string.empty?
      string.to_f
    end
  end

  def get_date(parent, selector)
    if (string = get_string(parent, selector)) && !string.empty?
      string.split('/').reverse.join('-')
    end
  end

  def strip_multiple_spaces(string)
    if string
      string.strip.gsub(/\s+/m, ' ')
    end
  end

  def strip_spaces(string)
    if string
      string.gsub(/\s+/m, '')
    end
  end

end

# file_name = "data/126/126825.html"
puts SourceFile.results_header.to_csv
year_filter = ARGV[0]
file_filter = ARGV[1]
Dir["data/#{year_filter}*/#{file_filter}*.xml"].each do |file_name|
  SourceFile.new(file_name).results.each{|r| $stdout.puts r.to_csv}
  $stdout.flush
end

$stderr.puts "\n*** error_count=#{$error_count}" if $error_count > 0
