#!/usr/bin/env ruby

require 'rubygems'
require 'prawn'

LANGUAGE = 'lt'

ROOT_DIR = File.join(File.dirname(__FILE__), '..')
TEMPLATES_DIR = File.join(ROOT_DIR, 'templates', LANGUAGE)
TOP_IMAGES = %w{gnat scorpion spy}.map do |name|
  File.join(TEMPLATES_DIR, 'top_%s.jpg' % name)
end
BOTTOM_IMAGE = File.join(TEMPLATES_DIR, 'bottom.jpg')
OUTPUT_DIR = File.join(ROOT_DIR, 'output')
IMAGE_SIZE = [520, 246]
IMAGE_SPACING = 10
# x, y, w, h
KEY_COORDS = [21, -149, 477, 25]
IMAGES_PER_PAGE = 3

KEYS = %w{

}

def putsnl(text)
  $stdout.write(text)
  $stdout.flush
end

def each_key(document)
  image_index = 0
  KEYS.each do |key|
    if image_index == IMAGES_PER_PAGE
      image_index = 0
      document.start_new_page
    end

    yield key, image_index

    image_index += 1
  end
end

def image_coords(image_index)
  [0, (image_index + 1) * IMAGE_SIZE[1] + IMAGE_SPACING * image_index]
end

putsnl "Generating front "
Prawn::Document.generate(File.join(OUTPUT_DIR, 'fronts.pdf'),
:page_size => "A4") do
  each_key(self) do |key, image_index|
    image TOP_IMAGES[image_index], :fit => IMAGE_SIZE, 
      :at => image_coords(image_index)

    putsnl "."
  end

  puts " Done."
end

putsnl "Generating back  "
Prawn::Document.generate(File.join(OUTPUT_DIR, 'backs.pdf'),
:page_size => "A4") do  
  each_key(self) do |key, image_index|
    coords = image_coords(image_index)
    image BOTTOM_IMAGE, :fit => IMAGE_SIZE, :at => coords

    text_coords = [coords[0] + KEY_COORDS[0], coords[1] + KEY_COORDS[1]]
    options = {
      :width => KEY_COORDS[2],
      :height => KEY_COORDS[3],
      :overflow => :shrink_to_fit,
      :at => text_coords,
      :align => :center,
      :valign => :center,
      :document => self
    }

#    stroke_color("555555")
#    fill_color("ffeeee")
#    fill_and_stroke_rectangle(options[:at],
#                                  options[:width],
#                                  options[:height])
#    fill_color("000000")

    box = Prawn::Text::Box.new(key, options)
    box.render
    
    putsnl "."
  end

  puts " Done."
end

puts "Done."