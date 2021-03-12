# frozen_string_literal: true

RSpec.describe 'InlineAsset' do
  let(:helper) { ::IziLightup::InlineAsset }

  it 'should work' do
    data = helper.inline_file('test')
    expect(data).to eq false
  end
end
