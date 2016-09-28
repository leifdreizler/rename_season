#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'optparse'
require 'csv'

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
  
def check_rename(files, episode_array)
  total_files = files.zip(episode_array).length
  matched_files = 0

  files.zip(episode_array).each do |original_file, episode_title|
    new_filename = episode_title + quality(original_file) + File.extname(original_file)
    path_and_file = File.dirname(original_file) + "/" + new_filename.gsub(/:/,'')

    # quick check to see if the s##e## string in the original file and the proposed filename match
    # this provides some quick and basic verification that things are lined up
    if new_filename.match(/(s\d\de\d\d)/i).to_s == (path_and_file.match(/(s\d\de\d\d)/i)).to_s
       matched_files += 1
    end

    puts "proposed rename... \n" + original_file + "\n" + path_and_file + "\n"
  end

  puts "\n" + total_files.to_s + " checked, " + matched_files.to_s + " matched (these numbers should be equal, if not consider abort)"
  print "Type yes if everything looks ok: "
  answer = gets.chomp

  if answer.to_s != "yes"
    exit
  end
end

def title_builder(show, season, episode_number, episode_name)
  filename = show + ' S' + pad(season) + 'E' + pad(episode_number) + ' ' + episode_name.gsub("/"," ")
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
  
  check_rename(files, episode_array)

  files.zip(episode_array).each do |file, episode|
    rename_file(file, episode)
  end       
end

def parse_seasons(seasons)
  season_list = seasons.split(/\s*,\s*/)

  season_list.each_with_index do |season, index|
    if season.include? "-"
      (season[0]..season[2]).each do |x| 
        season_list.push(x)
      end
    season_list.delete_at(index)
    end
  end

  return season_list.sort
end

def iterate_seasons(seasons_list, imdb_id, source_dir)
 if seasons_list.length == 1
   season_info = get_season_info(imdb_id, seasons_list[0])
   season_array = format_season_info(season_info)
   season_iterator(source_dir, season_array)
 else
   if seasons_list.length != num_seasons(source_dir)
     puts "number of season folders didn't match the number of seasons to parse from IMDB"
     exit
   else
    files = Dir.glob(source_dir + "/*").sort_by{|word| word.downcase}

    puts "proposed matching..."
    files.zip(seasons_list).each do |season_folder, season_number|
      puts season_number + " to " + season_folder + "\n"
    end 
   
    print "Type yes if everything looks ok: "
    answer = gets.chomp

    if answer.to_s != "yes"
      exit
    end

    files.each_with_index do |season, index|
      season_info = get_season_info(imdb_id, seasons_list[index])
      season_array = format_season_info(season_info)
      season_iterator(season, season_array)
    end

  end
 end

end

def num_seasons(source_dir)
 return Dir.glob(source_dir + "/*").select {|f| File.directory? f}.length
end

source_dir = ""#string to directory, don't put trailing /
imdb_id = "" #string of IMDB ID, the part after title in: http://www.imdb.com/title/tt0472954 
seasons = "" #string of season number. 2, 3, 4-5, or just a single season. 
#If doing multiple seasons, you need to have the source_dir be a dir of dirs

iterate_seasons(parse_seasons(seasons), imdb_id, source_dir)
