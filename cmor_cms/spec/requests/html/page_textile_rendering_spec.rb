require 'rails_helper'

describe 'textile rendering' do
  it 'converts textile to html' do
    page_model = Cmor::Cms::Page.create! do |page|
      page.pathname  = '/'
      page.basename  = 'foo'
      page.locale    = 'en'
      page.format    = ''
      page.handler   = 'textile'
      page.title     = 'Home'
      page.body      = 'h1. Home'
      page.published = true
    end
    get '/en/foo'

    expect(response.body).to include('<h1>Home</h1>')
  end
end
