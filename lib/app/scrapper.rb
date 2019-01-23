require 'rubygems'
require 'json'
require 'nokogiri'
require 'open-uri'

class Scrapper
    attr_accessor :email_mairies

# méthode permettant d'extraire les données dans un fichié emails.json 
def save_as_json
    File.open("db/emails.json","w") do |f|
      f.write(@email_mairies.to_json)
    end
end

# méthode permettant d'extraire les données dans un tableaux google spredsheet, ci-cela ne fonctionne pas remplacer "11BoOiynwy-wC0qGmoNoSoZXUiBx8EOwgpd-fBBXX6Eg" par celui d'une de vos feuilles perso sur google spreadsheet
def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("credentials.json")
    spread = session.spreadsheet_by_key("11BoOiynwy-wC0qGmoNoSoZXUiBx8EOwgpd-fBBXX6Eg").worksheets[0]
    spread[2,1] = "Villes"
    spread[2,2] = "Emails"
    i = 3
    @email_mairies.each do |k,v|
        spread[i,1] = k
        spread[i,2] = v
        i +=1
      end
    spread.save
end

# méthode permettant d'extraire les données dans un fichié emails.csv
def save_as_csv
    CSV.open("db/emails.csv", "w") do |csv|
        @email_mairies.each do |k,v|
        csv << [k,v]
        end
    end

end


# ci-dessosu et jusqu'a rb70 il s'agit du code de scrapping réalisé la semaine derniere

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
  
  # On définit le résultat du scrapping comme une instance de l'objet Scrapper 
  def initialize()
    @email_mairies = get_all_email(url_and_name())
  end
  
end