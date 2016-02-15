require 'rails_helper'

feature 'User signs in' do
	scenario 'with valid credentials' do
		visit '/'
    expect(page.status_code) == '200'
		fill_in 'session_username', with: 'dhollerich'
		fill_in 'session_password', with: "DDhh2008"
		click_on 'Log In'
		expect(page).to have_content('My Map')
  end
  scenario 'with invalid credentials' do
    visit '/'
    expect(page.status_code) == '200'
    fill_in 'session_username', with: 'rgjkfgjfkjgfgk'
    fill_in 'session_password', with: 'dgffkgfgnfn'
    click_on 'Log In'
    expect(page).to have_content('Login failed. Please try again.')
  end
  scenario 'signs in then out' do
		visit '/'
		expect(page.status_code) == '200'
		expect(page).to have_content('I forgot')
		fill_in 'session_username', with: 'dhollerich'
		fill_in 'session_password', with: "DDhh2008"
		click_on 'Log In'
		expect(page).to have_content('My Map')
    click_on 'Sign Out'
    expect(page.status_code) == '200'
    expect(page).to have_content('I forgot')
  end
end