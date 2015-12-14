require 'rails_helper'

RSpec.describe Search, type: :model do
  it { should have_many(:products) }
  it { should validate_presence_of(:query) }

  it 'has a valid factory' do
    expect(create(:search)).to be_valid
  end

  describe '.fetch_products' do
    it 'expects crawler with crawler settings' do
      allow(Settings).to receive(:ebay).and_return(double(crawler: true))
      expect(subject).to receive(:fetch_products_with_crawler)
      subject.fetch_products
    end

    it 'expects api without crawler settings' do
      allow(Settings).to receive(:ebay).and_return(double(crawler: false))
      expect(subject).to receive(:fetch_products_with_api)
      subject.fetch_products
    end
  end

  describe '.fetch_products_with_api' do
    it 'should call create_from_api' do
      api_item = double(:api_item)
      allow(subject).to receive(:api_items).and_return([api_item])
      expect(Product).to receive(:create_from_api).with(api_item)
      subject.fetch_products_with_api
    end
  end

  describe '.fetch_products_with_crawler' do
    it 'should call create_from_crawler' do
      crawler_item = double(:crawler_item)
      allow(subject).to receive(:crawler_items).and_return([crawler_item])
      expect(Product).to receive(:create_from_crawler).with(crawler_item)
      subject.fetch_products_with_crawler
    end
  end

  describe '.api_items' do
    before do
      allow(subject).to receive(:api_data).and_return(
        JSON.load(File.read('spec/fixtures/searches/api.json'))
      )
    end

    it 'returns 100 items as JSON' do
      expect(subject.api_items.size).to eq(100)
    end

    it 'has name and link fields in first result' do
      item = subject.api_items.first
      expect(item['title'][0]).to eq('Nikon D5000 12.3 MP Digital SLR Camera - Black')
      expect(item['viewItemURL'][0]).to eq('http://www.ebay.com/itm/Nikon-D5000-12-3-MP-Digital-SLR-Camera-Black-/252203147637')
    end
  end

  describe '.api_data' do
    it 'should call JSON.load' do
      expect(JSON).to receive(:load)
      subject.api_data
    end
  end

  context 'with crawler' do
    before do
      allow(subject).to receive(:crawler_page).and_return(
        File.read('spec/fixtures/searches/crawler.html')
      )
    end

    describe '.crawler_items' do
      it 'has 50 items' do
        expect(subject.crawler_items.size).to eq(50)
      end
    end

    describe '.crawler_data' do
      it 'has Nokogiri class' do
        expect(subject.crawler_data.class).to eq(Nokogiri::HTML::Document)
      end
    end

    describe '.crawler_url' do
      it 'has correct ebay url' do
        subject.query = 'Canon'
        expect(subject.crawler_url).to eq('http://www.ebay.com/sch/i.html?_nkw=Canon')
      end
    end
  end
end
