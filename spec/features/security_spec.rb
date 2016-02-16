require 'rails_helper'

feature 'has privileges and security' do
  scenario 'should not allow a non-logged in user to view /users' do
    visit '/users'
    expect(page.status_code) == '200'
    expect(page).to have_content('Please login to continue.')
    expect(page).not_to have_content('Welcome')
    expect(page).not_to have_content('My Map')
  end
  scenario 'should not allow a non-logged in user to view /users' do
    visit '/admin'
    expect(page.status_code) == '200'
    expect(page).to have_content('Please login to continue.')
    expect(page).not_to have_content('Welcome')
    expect(page).not_to have_content('My Map')
    expect(page).not_to have_content('My Account')
    expect(page).not_to have_content('Admin')
  end
end