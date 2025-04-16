require 'nokogiri'
require 'uri'
require 'json'

class CarouselParser
  LAYOUTS = [
    {
      container: 'div.iELo6',
      name:      'div.pgNMRc',
      date:      'div.cxzHyb',
      image:     'img'
    },
    {
      container: 'div.o6OF0',
      name:      '.SHFPkb',
      date:      '.bTSf5c',
      image:     '.XAFD5c'
    },
    
  ]

  def initialize(html_file)
    begin
      @doc = Nokogiri::HTML(File.read(html_file))
    rescue Errno::ENOENT
      raise Errno::ENOENT, "File not found: #{html_file}"
    end
  end

  def parse
    cards_with_layout = LAYOUTS.flat_map do |layout|
      @doc.css(layout[:container]).map { |card| [card, layout] }
    end

    cards_with_layout.map do |card, layout|
      extract_card(card, layout)
    end.compact
  end

  def to_json
    JSON.pretty_generate(parse)
  end

  private

  def extract_card(card, layout)
    name_el = card.at_css(layout[:name])
    date_el = card.at_css(layout[:date])
    img_el  = card.at_css(layout[:image])
    link_el = card.at_css('a')

    return nil unless name_el && date_el && img_el && link_el

    thumb = if img_el['src'] && !img_el['src'].empty?
              img_el['src']
            elsif (style = img_el['style']) && style[/url\(["']?(.*?)["']?\)/,1]
              style[/url\(["']?(.*?)["']?\)/,1]
            end

    {
      'name'       => name_el.text.strip,
      'extensions' => [ date_el.text.strip ],
      'link'       => URI.join('https://www.google.com', link_el['href']).to_s,
      'image'  => thumb.to_s
    }
  end
end
