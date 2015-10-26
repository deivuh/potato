#!/usr/bin/env ruby

require 'tvdb_party'
require 'addic7ed'






filenames = ARGV

filenames.each do | filename |

  file_dir = filename.match /^([\w\W]+\/)[\w\W]+.m[\w]{2}$/

  if file_dir
    file_dir = file_dir.captures[0]
  else
    file_dir = ""
  end

  ep_sub_info = Addic7ed::Episode.new(filename.strip)
  puts ep_sub_info.download_best_subtitle!('en')


  #
  filename_no_ext_match = filename.match /^([\w\W]+).(m[\w]{2})$/

  if filename_no_ext_match
    filename_no_ext = filename_no_ext_match.captures[0]
    filename_ext = filename_no_ext_match.captures[1]


    # regex = /^[\d\D]*[Ss](\d\d)[Ee]([0-9][0-9])[\d\D]*$/
    regex = /^([\w\W]+).S(\d\d)E([0-9][0-9])[\d\D]*$/

    filename = filename.to_s;

    # puts filename
    # Boardwalk.Empire.S05E01.720p.HDTV.x264-KILLERS
    # Homeland - 04x01 - The Drone Queen.mkv

    matching = filename.match regex

    if matching
      parsed_show_name = matching.captures[0].gsub('.',' ')
      season = matching.captures[1]
      episode = matching.captures[2]
      puts "Parsed show name: #{parsed_show_name}"
      tvdb = TvdbParty::Search.new("53BFFAFDEABC08B3")  
      results = tvdb.search(parsed_show_name)
      # puts "Results: #{results}"  
      first_result = results.first
      puts "First result: #{first_result}"
      show_id = first_result["seriesid"]
      puts "Show id: #{show_id}"      
      show = tvdb.get_series_by_id(show_id)
      show_name = show.name
      puts "Show name #{show_name}"
      puts "Season #{season} Episode #{episode}"
      episode_name = show.get_episode(season.to_i, episode.to_i).name      
      puts "Episode name: #{episode_name}"


      puts "Renaming video file: #{file_dir}#{filename_no_ext}.#{filename_ext}" 
      File.rename("#{file_dir}#{filename_no_ext}.#{filename_ext}" , "#{show_name} - #{season}x#{episode} - #{episode_name}.#{filename_ext}")
      puts "Renaming subtitle file: #{file_dir}#{filename_no_ext}.en.srt" 
      File.rename("#{file_dir}#{filename_no_ext}.en.srt" , "#{show_name} - #{season}x#{episode} - #{episode_name}.en.srt")


    end




  end




end
