require 'rails_helper'

feature 'User signs  in' do
	scenario 'with valid credentials' do
		visit '/'
		fill_in 'session[username]', with: 'dhollerich'
		fill_in 'session[password]', with: "DDhh2008"
		click_on 'Log In'
		expect(page).to have_content('My Map')
	end
end