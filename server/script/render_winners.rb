#!/usr/bin/env ruby
if ARGV.size < 1
  puts "Usage: #{$0} data_file"
  exit
end

PART_DATE = 'date'
PART_PLAYER_RATINGS = 'ratings'
PART_ALLIANCE_RATINGS = 'alliance_ratings'

LABEL_INDEX = "Turinys"
LABEL_GALAXY_WIN_DATE = "Galaktikos laimėjimo data"
LABEL_ALLIANCES = "Sąjungos"
LABEL_PLAYERS = "Žaidėjai"
LABEL_TITLE = "Galaktikos laimėtojai"
LABEL_WITHOUT_ALLIANCE = "Be sąjungos"
LABEL_TO_ALLIANCES = "[^] Sąjungos"
LABEL_TO_TOP = "[^] Į pradžią"

LABEL_NO = "#"
LABEL_ALLIANCE = "Sąjunga"
LABEL_PLAYER = "Žaidėjas"
LABEL_PLAYERS_COUNT = "Žaidėjų"
LABEL_PLANETS_COUNT = "Planetų"
LABEL_ECONOMY_POINTS = "Ekonomikos taškai"
LABEL_SCIENCE_POINTS = "Mokslo taškai"
LABEL_ARMY_POINTS = "Kariuomenės taškai"
LABEL_WAR_POINTS = "Karo taškai"
LABEL_ALLIANCE_VICTORY_POINTS = "Sąjungos pergalės taškų"
LABEL_VICTORY_POINTS = "Pergalės taškų"
LABEL_TOTAL_POINTS = "Bendri taškai"

ATTR_ID = 'id'
ATTR_ALLIANCE = 'alliance'
ATTR_ALLIANCE_ID = 'alliance_id'
ATTR_NAME = 'name'
ATTR_PLAYERS_COUNT = 'players_count'
ATTR_PLANETS_COUNT = 'planets_count'
ATTR_ECONOMY_POINTS = 'economy_points'
ATTR_SCIENCE_POINTS = 'science_points'
ATTR_ARMY_POINTS = 'army_points'
ATTR_WAR_POINTS = 'war_points'
ATTR_ALLIANCE_VICTORY_POINTS = 'alliance_vps'
ATTR_VICTORY_POINTS = 'victory_points'
ATTR_TOTAL_POINTS = 'total_points'

NAME_TOP = "top"
NAME_ALLIANCES = "alliances"
NAME_PLAYERS = "players"

require File.dirname(__FILE__) + '/../lib/initializer.rb'
require 'builder'

def read_data(filename)
  data = JSON.parse(File.read(filename))

  # Calculate total points for each row.
  [data[PART_PLAYER_RATINGS], data[PART_ALLIANCE_RATINGS]].each do |ratings|
    ratings.each do |row|
      row[ATTR_TOTAL_POINTS] = total_points(row)
    end
  end

  # Sort players
  #   {
  #     "id" => Fixnum (player ID),
  #     "name" => String (player name),
  #     "victory_points" => Fixnum,
  #     "alliance_vps" => Fixnum,
  #     "planets_count" => Fixnum,
  #     "war_points" => Fixnum,
  #     "science_points" => Fixnum,
  #     "economy_points" => Fixnum,
  #     "army_points" => Fixnum,
  #     "alliance" => {"id" => Fixnum, "name" => String} | nil,
  #     "last_seen" => true (currently online) | Time | nil (never logged in),
  #   }
  data[PART_PLAYER_RATINGS].sort! do |r1, r2|
    status = (r1[ATTR_VICTORY_POINTS] <=> r2[ATTR_VICTORY_POINTS]) * -1
    status = (r1[ATTR_TOTAL_POINTS] <=> r2[ATTR_TOTAL_POINTS]) * -1 \
      if status == 0
    status = (r1[ATTR_PLANETS_COUNT] <=> r2[ATTR_PLANETS_COUNT]) * -1 \
      if status == 0
    status == 0 ? r1[ATTR_ID] <=> r2[ATTR_ID] : status
  end

  # Sort alliances
  # {
  #   'players_count'   => Fixnum, # Number of players in the alliance.
  #   'alliance_id'     => Fixnum, # ID of the alliance
  #   'name'            => String, # Name of the alliance
  #   'war_points',     => Fixnum, # Sum of alliance war points
  #   'army_points',    => Fixnum, # -""-
  #   'science_points', => Fixnum, # -""-
  #   'economy_points', => Fixnum, # -""-
  #   'victory_points', => Fixnum, # -""-
  #   'planets_count',  => Fixnum  # -""-
  # }
  data[PART_ALLIANCE_RATINGS].sort! do |r1, r2|
    status = (r1[ATTR_VICTORY_POINTS] <=> r2[ATTR_VICTORY_POINTS]) * -1
    status = (r1[ATTR_TOTAL_POINTS] <=> r2[ATTR_TOTAL_POINTS]) * -1 \
      if status == 0
    status = (r1[ATTR_PLAYERS_COUNT] <=> r2[ATTR_PLAYERS_COUNT]) * -1 \
      if status == 0
    status == 0 ? r1[ATTR_ALLIANCE_ID] <=> r2[ATTR_ALLIANCE_ID] : status
  end

  data
end

def total_points(row)
  row[ATTR_ECONOMY_POINTS] + row[ATTR_SCIENCE_POINTS] +
    row[ATTR_ARMY_POINTS] + row[ATTR_WAR_POINTS]
end

def to_top(b)
  b.a LABEL_TO_TOP, :href => "##{NAME_TOP}"
end

def player_id(row)
  "player_#{row[ATTR_ID]}"
end

def alliance_id(row)
  "alliance_#{row[ATTR_ALLIANCE_ID]}"
end

def alliance_row_id(row)
  "alliance_row_#{row[ATTR_ALLIANCE_ID]}"
end

def alliances(b, data)
  b.h1 do
    b.a LABEL_ALLIANCES, :name => NAME_ALLIANCES
  end

  b.table do
    b.tr do
      b.th LABEL_NO
      b.th LABEL_ALLIANCE
      b.th LABEL_PLAYERS_COUNT
      b.th LABEL_PLANETS_COUNT
      b.th LABEL_ECONOMY_POINTS
      b.th LABEL_SCIENCE_POINTS
      b.th LABEL_ARMY_POINTS
      b.th LABEL_WAR_POINTS
      b.th LABEL_VICTORY_POINTS
      b.th LABEL_TOTAL_POINTS
    end

    data[PART_ALLIANCE_RATINGS].each_with_index do |row, index|
      b.tr do
        b.td index + 1
        b.td do
          b.a row[ATTR_NAME], :href => "##{alliance_id(row)}",
              :name => alliance_row_id(row)
        end
        b.td row[ATTR_PLAYERS_COUNT]
        b.td row[ATTR_PLANETS_COUNT]
        b.td row[ATTR_ECONOMY_POINTS]
        b.td row[ATTR_SCIENCE_POINTS]
        b.td row[ATTR_ARMY_POINTS]
        b.td row[ATTR_WAR_POINTS]
        b.td row[ATTR_VICTORY_POINTS]
        b.td row[ATTR_TOTAL_POINTS]
      end
    end
  end

  to_top(b)

  alliance_players = data[PART_PLAYER_RATINGS].inject({}) do |hash, row|
    unless row[ATTR_ALLIANCE].nil?
      alliance_id = row[ATTR_ALLIANCE][ATTR_ID]
      hash[alliance_id] ||= []
      hash[alliance_id].push row
    end

    hash
  end

  data[PART_ALLIANCE_RATINGS].each do |alliance|
    alliance_id = alliance[ATTR_ALLIANCE_ID]

    b.h2 do
      b.a alliance[ATTR_NAME], :name => alliance_id(alliance),
          :href => "##{alliance_row_id(alliance)}"
    end

    b.table do
      b.tr do
        b.th LABEL_NO
        b.th LABEL_PLAYER
        b.th LABEL_PLANETS_COUNT
        b.th LABEL_ECONOMY_POINTS
        b.th LABEL_SCIENCE_POINTS
        b.th LABEL_ARMY_POINTS
        b.th LABEL_WAR_POINTS
        b.th LABEL_ALLIANCE_VICTORY_POINTS
        b.th LABEL_VICTORY_POINTS
        b.th LABEL_TOTAL_POINTS
      end

      alliance_players[alliance_id].each_with_index do |row, index|
        b.tr do
          b.td index + 1
          b.td do
            b.a row[ATTR_NAME], :href => "##{player_id(row)}"
          end
          b.td row[ATTR_PLANETS_COUNT]
          b.td row[ATTR_ECONOMY_POINTS]
          b.td row[ATTR_SCIENCE_POINTS]
          b.td row[ATTR_ARMY_POINTS]
          b.td row[ATTR_WAR_POINTS]
          b.td row[ATTR_ALLIANCE_VICTORY_POINTS]
          b.td row[ATTR_VICTORY_POINTS]
          b.td row[ATTR_TOTAL_POINTS]
        end
      end
    end

    b.p do
      b.a LABEL_TO_ALLIANCES, :href => "##{NAME_ALLIANCES}"
    end
  end
end

def players(b, data)
  b.h1 do
    b.a LABEL_PLAYERS, :name => NAME_PLAYERS
  end

  b.table do
    b.tr do
      b.th LABEL_NO
      b.th LABEL_PLAYER
      b.th LABEL_ALLIANCE
      b.th LABEL_PLANETS_COUNT
      b.th LABEL_ECONOMY_POINTS
      b.th LABEL_SCIENCE_POINTS
      b.th LABEL_ARMY_POINTS
      b.th LABEL_WAR_POINTS
      b.th LABEL_VICTORY_POINTS
      b.th LABEL_TOTAL_POINTS
    end

    data[PART_PLAYER_RATINGS].each_with_index do |row, index|
      b.tr do
        b.td index + 1
        b.td do
          b.a row[ATTR_NAME], :name => player_id(row)
        end
        if row[ATTR_ALLIANCE]
          b.td do
            b.a row[ATTR_ALLIANCE][ATTR_NAME],
                # This is evil.
                :href => "##{alliance_id(
                  {ATTR_ALLIANCE_ID => row[ATTR_ALLIANCE][ATTR_ID]}
                )}"
          end
        else
          b.td LABEL_WITHOUT_ALLIANCE
        end
        b.td row[ATTR_PLANETS_COUNT]
        b.td row[ATTR_ECONOMY_POINTS]
        b.td row[ATTR_SCIENCE_POINTS]
        b.td row[ATTR_ARMY_POINTS]
        b.td row[ATTR_WAR_POINTS]
        b.td row[ATTR_VICTORY_POINTS]
        b.td row[ATTR_TOTAL_POINTS]
      end
    end
  end
  
  to_top(b)
end

data = read_data(ARGV[0])

b = Builder::XmlMarkup.new(:indent => 2)

html = b.html do
  b.head do
    b.meta "http-equiv" => "Content-Type",
           "content" => "text/html;charset=UTF-8"
    b.title LABEL_TITLE
  end
  b.body do
    b.a :name => NAME_TOP

    b.h1 LABEL_INDEX
    b.ul do
      b.li { b.a LABEL_ALLIANCES, :href => "##{NAME_ALLIANCES}" }
      b.li { b.a LABEL_PLAYERS, :href => "##{NAME_PLAYERS}" }
    end

    b.h1 LABEL_GALAXY_WIN_DATE
    b.p Time.parse(data[PART_DATE]).to_s(:db)
    
    alliances(b, data)
    players(b, data)
  end
end

File.open("#{ARGV[0]}.html", "w") do |f|
  f.write html.to_s
end
puts "Done."