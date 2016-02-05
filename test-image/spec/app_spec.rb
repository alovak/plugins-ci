require 'spec_helper'

describe 'something' do
  it 'should do' do
    visit "/product/demo"

    expect(page).to have_content 'Demo Description'
  end
end
