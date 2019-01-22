require 'rubygems'
require 'json'
require 'nokogiri'
require 'open-uri'

class Scrapper
    attr_accessor :email_mairies

def save_as_JSON
   # tempHash = {
        #"key_a" => "val_a",
       # "key_b" => "val_b"
   # }
    File.open("db/emails.json","w") do |f|
      f.write(@email_mairies.to_json)
    end
end




def url_and_name
    url = "http://annuaire-des-mairies.com/val-d-oise.html"
    doc = Nokogiri::HTML(open(url))
    url_path = doc.css("a[href].lientxt")
    name_and_url = []
  
    url_path.map do |value|
      url_ville = value["href"]
      url_ville[0] = ""
      name_and_url << { "name" => value.text, "url" => "http://annuaire-des-mairies.com" + url_ville }
    end
    name_and_url
  end
  
  def get_townhall_email(url)
    doc = Nokogiri::HTML(open(url))
    email = doc.xpath("/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]").text
  end
  
  def get_all_email(name_and_url)
    name_and_email = []
  
    name_and_url.map.with_index do |value, i|
      name_and_email << {value["name"] => get_townhall_email(value["url"])}
      break if i == 5 
    end
    name_and_email
    name_and_email.reduce Hash.new, :merge
  end
  
  def initialize()
    @email_mairies = get_all_email(url_and_name())
  end
  
end