require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper
    url = "https://www.soccerstats.com/latest.asp?league=england"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    # Club name.
    club_total = parsed_page.css('table#btable').css('tr.odd').css("[align='left']").css("[target='_top']")
    @club_name = club_total.map{|club| club.text.strip}.uniq
    # Games played.
    games_total = parsed_page.css('h2+ #btable td:nth-child(3) font')
    @games_played = games_total.map{|played| played.text.strip}
    # Goal difference.
    goals_total = parsed_page.css('#btable td:nth-child(9) font')
    @goal_diff = goals_total.map{|diff| diff.text.strip}
    # Points.
    points_total = parsed_page.css('#btable td:nth-child(10)').css('[bgcolor="#e0e0e0"]')
    @points_each = points_total.map{|points| points.text.strip}
    # Table.
    def pl_table
        n = -1
        while n <= 18 do n += 1
            puts [ @club_name[n], @games_played[n], @goal_diff[n], @points_each[n]].join(', ')
        end
    end
    byebug
end

scraper
