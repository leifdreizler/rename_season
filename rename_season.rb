#!/usr/bin/ruby

require 'net/http'
require 'json'

def get_season_info(id, season)
	source='http://www.omdbapi.com/?i=' + id + '&Season=' + season
	
	url = URI.parse(source)
	req = Net::HTTP::Get.new(url.to_s)
	res = Net::HTTP.start(url.host, url.port) {|http|http.request(req)}
	return res.body
end

def format_season_info(json)
	blob = JSON.parse(json)	
	title = blob["Title"]
	season = blob["Season"]
	
	formatted_season_info = []
	blob["Episodes"].each do |i|
		formatted_season_info << title_builder(title, season, i["Episode"], i["Title"])
	end
	
	return formatted_season_info
end

def rename_file(original_file, episode_title)	
	new_filename = episode_title + quality(original_file) + File.extname(original_file)
	path_and_file = File.rename(original_file, File.dirname(original_file) + "/" + new_filename.gsub(/:/,''))
	return path_and_file
end

def check_rename_file(original_file, episode_title)	
	new_filename = episode_title + quality(original_file) + File.extname(original_file)
	path_and_file = File.dirname(original_file) + "/" + new_filename.gsub(/:/,'')
	puts "renaming... \n" + original_file + "\n" + path_and_file + "\n"
end

def title_builder(show, season, episode_number, episode_name)
         filename = show + ' S' + pad(season) + 'E' + pad(episode_number) + ' ' + episode_name
	 return filename
end

def pad(number)
	num = number.to_i
	if num < 10 
		return "0" + number
	else
		return number
	end
end	

def quality(file)
	if file.include? "480p"
		return " [480p]"
	elsif file.include? "576p"
		return " [576p]"
	elsif file.include? "720p"
		return " [720p]"
	elsif file.include? "1080p"
		return " [1080p]"
	else
		return ""
	end
end



def season_iterator(source_dir, episode_array)
    files = Dir.glob(source_dir + "/*").sort_by{|word| word.downcase}

    files.zip(episode_array).each do |file, episode|
        check_rename_file(file, episode)
    end

	print "\n\nEverything look ok? "
	answer = gets.chomp

	if answer.to_s != "yes"
		exit
	end

    files.zip(episode_array).each do |file, episode|
        rename_file(file, episode)
    end
       
end




source_dir = #string to directory 
imdb_id =  #string of IMDB ID, the part after title in: http://www.imdb.com/title/tt0472954 
season_number = #string of season number

season_info = get_season_info(imdb_id, season_number)
season_array = format_season_info(season_info)
season_iterator(source_dir, season_array)

