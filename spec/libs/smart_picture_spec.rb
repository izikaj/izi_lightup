# frozen_string_literal: true

RSpec.describe 'SmartPicture' do
  let(:helper) { ::IziLightup::SmartPicture }

  it 'should work' do
    expect(helper).to respond_to :render
  end
end
