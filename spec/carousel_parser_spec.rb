# spec/carousel_parser_spec.rb

require 'spec_helper'
require 'carousel_parser'

RSpec.describe CarouselParser do
  fixtures = {
    'Van Gogh'          => 'files/van-gogh-paintings.html',
    'Picasso'           => 'spec/fixtures/picasso-paintings.html',
    'Leonardo da Vinci' => 'spec/fixtures/leonardo-da-vinci-paintings.html'
  }

  fixtures.each do |label, path|
    context "parsing #{label} page" do
      let(:parser) { described_class.new(path) }
      let(:items)  { parser.parse }

      it 'returns an Array with at least one item' do
        expect(items).to be_an(Array)
        expect(items).not_to be_empty
      end

      it 'each item has the 4 required keys' do
        items.each do |item|
          expect(item).to include('name', 'extensions', 'link', 'image')
        end
      end

      it 'keys have the correct types' do
        first = items.first
        expect(first['name']).to be_a(String)
        expect(first['extensions']).to be_an(Array)
        expect(first['link']).to be_a(String)
        expect(first['image']).to be_a(String)
      end
    end
  end

  describe '#to_json' do
    it 'generates valid JSON for the Van Gogh page' do
      json = CarouselParser.new(fixtures['Van Gogh']).to_json
      expect { JSON.parse(json) }.not_to raise_error
    end
  end
end
