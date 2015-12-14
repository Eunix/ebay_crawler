require 'rails_helper'

RSpec.describe Product, type: :model do
  it { should belong_to(:search) }

  it 'has a valid factory' do
    expect(create(:product)).to be_valid
  end

  context 'with api' do
    let!(:search) { create(:search, query: 'Nikon') }

    before do
      allow(search).to receive(:api_data).and_return(
        JSON.load(File.read('spec/fixtures/searches/api.json'))
      )
    end

    describe '#create_from_api' do
      it 'creates new product' do
        product = Product.create_from_api(search.api_items.first)
        expect(product.name).to eq('Nikon D5000 12.3 MP Digital SLR Camera - Black')
        expect(product.link).to eq('http://www.ebay.com/itm/Nikon-D5000-12-3-MP-Digital-SLR-Camera-Black-/252203147637')
        expect(product.price).to eq(400.0)
      end
    end
  end

  context 'with crawler' do
    let!(:search) { create(:search, query: 'Canon') }

    before do
      allow(search).to receive(:crawler_page).and_return(
        File.read('spec/fixtures/searches/crawler.html')
      )
    end

    describe '#create_from_crawler' do
      it 'creates new product' do
        product = Product.create_from_crawler(search.crawler_items.first)
        expect(product.name).to eq('Nikon (черный) D3300 цифровая Зеркальная Камера тела с 18-55 мм VR II объектив')
        expect(product.link).to eq('http://www.ebay.com/itm/Nikon-Black-D3300-Digital-SLR-Camera-Body-with-18-55mm-VR-II-Lens-/291258487187?hash=item43d05bd193:g:y48AAOSwymxVMeNd')
        expect(product.price).to eq(28643.11)
      end
    end
  end
end
