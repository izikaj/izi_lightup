# frozen_string_literal: true

RSpec.describe 'InlineAsset' do
  let(:helper) { ::IziLightup::InlineAsset }

  it 'should work' do
    data = helper.inline_file('application.css')
    expect(data).to include 'APPLICATION_CSS'
  end
end
