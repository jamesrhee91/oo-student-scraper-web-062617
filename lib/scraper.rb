require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))

    doc.css("div.student-card").map do |student|
      student_info = {}
      student_info[:name] = student.css("h4.student-name").text
      student_info[:location] = student.css("p.student-location").text
      student_info[:profile_url] = student.css("a").attribute("href").value
      student_info
    end
  end

  def self.name_finder(url)
    url.split("/")[2].split(".com").join.split(".")[-1].to_sym
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    hash = {}
    doc.css("div.social-icon-container a").each do |icon|
      title = self.name_finder(icon.attribute("href").value)
      case title
      when :twitter
        hash[:twitter] = icon.attribute("href").value
      when :linkedin
        hash[:linkedin] = icon.attribute("href").value
      when :github
        hash[:github] = icon.attribute("href").value
      else
        hash[:blog] = icon.attribute("href").value
      end
    end
    hash[:profile_quote] = doc.css("div.profile-quote").text
    hash[:bio] = doc.css("div.description-holder p").text
    hash
  end

  def name_matcher(title)

  end

  def get_page
    doc = Nokogiri::HTML(open("http://students.learn.co/"))
  end

end

# Scraper.scrape_index_page
