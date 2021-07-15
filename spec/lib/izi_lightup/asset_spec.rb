# frozen_string_literal: true

RSpec.describe 'Asset' do
  let(:helper) { ::IziLightup::Asset }

  context '#[]' do
    it 'method should exist' do
      expect(helper).to respond_to :[]
    end

    it 'should return AssetInfo for existing asset' do
      expect(helper['sample.png']).to be_a ::IziLightup::AssetInfo
    end

    [
      ['sample.png', :png, 'image/png', [30, 30]],
      ['sample.jpg', :jpeg, 'image/jpeg', [499, 750]],
      ['sample.svg', :svg, 'image/svg+xml', [474, 474]],
      ['wrong.jpeg', nil, nil, nil]
    ].each do |(name, type, content_type, size)|
      it "allow to get asset [#{name}] type [#{type}]" do
        asset = helper[name]
        expect(asset&.type).to eq type
      end

      it "allow to get asset [#{name}] content_type [#{content_type}]" do
        asset = helper[name]
        expect(asset&.content_type).to eq content_type
      end

      it "allow to get asset [#{name}] size (dimentions) [#{content_type}]" do
        asset = helper[name]
        expect(asset&.size).to eq size
        expect(asset&.dimentions).to eq size
      end
    end

    it 'should allow to check file existence' do
      expect(helper['sample.png']).to be_a ::IziLightup::AssetInfo
    end

    it 'should return nil for non existing asset' do
      expect(helper['wrong.jpeg']).to be_nil
    end
  end

  # context '#asset_exist?' do
  #   it 'method should exist' do
  #     expect(helper).to respond_to :asset_exist?
  #   end

  #   it 'should check asset existence in asset pipeline' do
  #     expect(helper.asset_exist?('sample.png')).to be_truthy
  #     expect(helper.asset_exist?('sample.jpg')).to be_truthy
  #     expect(helper.asset_exist?('sample.svg')).to be_truthy
  #     expect(helper.asset_exist?('wrong.jpeg')).to be_falsy
  #   end
  # end

  # context '#asset_file' do
  #   it 'method should exist' do
  #     expect(helper).to respond_to :asset_file
  #   end

  #   %w[sample.png sample.jpg sample.svg].each do |name|
  #     it "should find #{name} path in asset pipeline" do
  #       result = helper.asset_file(name)
  #       expect(result).to be_present
  #       expect(result).to be_a(Pathname)
  #       expect(result).to exist
  #     end
  #   end

  #   it 'should return nil for non-existence assets' do
  #     expect(helper.asset_file('wrong.jpeg')).to be_nil
  #   end
  # end

  # context '#asset_type' do
  #   it 'method should exist' do
  #     expect(helper).to respond_to :asset_type
  #   end

  #   [
  #     ['sample.png', 'image/png'],
  #     ['sample.jpg', 'image/jpeg'],
  #     ['sample.svg', 'image/svg+xml'],
  #     ['wrong.jpeg', nil]
  #   ].each do |(name, type)|
  #     it "should detect content-type of #{name} asset [#{type.inspect}]" do
  #       expect(helper.asset_type(name)).to eq(type)
  #     end
  #   end
  # end

  # context '#asset_size' do
  #   it 'method should exist' do
  #     expect(helper).to respond_to :asset_size
  #   end

  #   [
  #     ['sample.png', [30, 30]],
  #     ['sample.jpg', [980, 666]],
  #     ['sample.svg', [474, 474]],
  #     ['wrong.jpeg', nil]
  #   ].each do |(name, type)|
  #     it "should detect sizes (dimentions) of #{name} asset" do
  #       expect(helper.asset_size(name)).to eq(type)
  #     end
  #   end
  # end
end
