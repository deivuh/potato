#!/usr/bin/env ruby

require 'sofa'
require 'addic7ed'
require 'nokogiri'

# File.open(ARGV[0]) do | file |



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
      parsed_show_name = matching.captures[0]
      season = matching.captures[1]
      episode = matching.captures[2]
      puts "Parsed show name: #{parsed_show_name}"
      show = Sofa::TVRage::Show.by_name(parsed_show_name)
      show_name = show.name
      puts "Show name #{show_name}"
      show_id = show.show_id
      puts "Show id: #{show_id}"
      url = "http://services.tvrage.com/myfeeds/episodeinfo.php?key=4f4oP0E4Ngy0NjPgz3uB&sid=#{show_id}&ep=#{season}x#{episode}"
      xml = Nokogiri::XML(open(url))
      episode_name = xml.at_xpath("show").at_xpath("episode").at_xpath("title").content
      puts "Episode name: #{episode_name}"


      File.rename("#{file_dir}#{filename_no_ext}.#{filename_ext}" , "#{show_name} - #{season}x#{episode} - #{episode_name}.#{filename_ext}")
      File.rename("#{file_dir}#{filename_no_ext}.srt" , "#{show_name} - #{season}x#{episode} - #{episode_name}.srt")


    end




  end




end
