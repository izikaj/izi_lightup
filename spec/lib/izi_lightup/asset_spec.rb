# frozen_string_literal: true

RSpec.describe 'Asset' do
  let(:helper) { ::IziLightup::Asset }

  context '#[]' do
    it 'method should exist' do
      expect(helper).to respond_to :[]
    end

    it 'should return AssetInfo for existing asset' do
      expect(helper['sample.png']).to be_a(::IziLightup::AssetInfo)
    end

    [
      ['sample.png', :png, 'image/png', [30, 30]],
      ['sample.jpg', :jpeg, 'image/jpeg', [499, 750]],
      ['sample.svg', :svg, 'image/svg+xml', [474, 474]],
      ['wrong.jpeg', nil, nil, nil]
    ].each do |(name, type, content_type, size)|
      it "allow to get asset [#{name}] type [#{type}]" do
        asset = helper[name]
        expect(asset&.type).to eq(type)
      end

      it "allow to get asset [#{name}] content_type [#{content_type}]" do
        asset = helper[name]
        expect(asset&.content_type).to eq(content_type)
      end

      it "allow to get asset [#{name}] size (dimentions) [#{content_type}]" do
        asset = helper[name]
        expect(asset&.size).to eq(size)
        expect(asset&.dimentions).to eq(size)
      end
    end

    it 'should allow to check file existence' do
      expect(helper['sample.png']).to be_a(::IziLightup::AssetInfo)
      expect(helper['sample.png'].exist?).to be_truthy
    end

    it 'should return nil for non existing asset' do
      expect(helper['wrong.jpeg']).to be_nil
    end
  end
end
