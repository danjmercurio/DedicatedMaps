require 'rails_helper'

feature 'account page' do
  scenario 'user logs in and views account page' do
    testUser = create(:user)
    visit '/'
    expect(page.status_code) == '200'
    fill_in 'session_username', with: 'newTestUser5000'
    fill_in 'session_password', with: 'password123456'
    click_on 'Log In'
    expect(page).to have_content('My Map')
    click_on 'My Account'
    expect(page.status_code) == '200'
    expect(page).to have_content('Don Hollerich')
  end
  scenario 'user clicks all top level sections' do
    visit '/'
    expect(page.status_code) == '200'
    fill_in 'session_username', with: 'dhollerich'
    fill_in 'session_password', with: "DDhh2008"
    click_on 'Log In'
    expect(page).to have_content('My Map')
    click_on 'My Account'
    click_on 'Clients'
    expect(page.status_code) == '200'
    expect(page).to have_content('Add new client')
    click_on 'Layers'
    expect(page.status_code) == '200'
    click_on 'Public Maps'
    expect(page.status_code) == '200'
    click_on 'Users'
    expect(page.status_code) == '200'
    click_on 'Assets'
    expect(page.status_code) == '200'
    click_on 'Tracking Devices'
    expect(page.status_code) == '200'
  end
end