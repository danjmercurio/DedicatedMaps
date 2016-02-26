require 'rails_helper'

feature 'Map display' do
  ### Since Google Maps API is now loaded asynchronously, our API key will be found in the Map JavaScript, not the DOM
  ### If we go back to loading the Maps API with a <script> tag in the layout, uncomment these tests.
  # scenario 'API key loads properly' do
  #   visit '/'
  #   expect(page.status_code) == '200'
  #   fill_in 'session_username', with: 'dhollerich'
  #   fill_in 'session_password', with: "DDhh2008"
  #   click_on 'Log In'
  #   expect(page).to have_content('My Map')
  #   expect(page.status_code) == '200'
  #   key = 'AIzaSyCXWCJQoRqKt74nUWgvJBmk_naVR-TbeBg'
  #   expect(page.html).to include(key)
  # end
  # scenario 'load script tag with correct api version and key' do
  #   visit '/'
  #   expect(page.status_code) == '200'
  #   fill_in 'session_username', with: 'dhollerich'
  #   fill_in 'session_password', with: "DDhh2008"
  #   click_on 'Log In'
  #   expect(page).to have_content('My Account')
  #   # Careful, this will only be true for the experimental version of the Google Maps API and proper key
  #   expect(page).to have_css("script#googleMaps[src='https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyCXWCJQoRqKt74nUWgvJBmk_naVR-TbeBg']",
  #                            :visible => false)
  # end
end