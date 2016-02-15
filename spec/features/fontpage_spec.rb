require 'rails_helper'

feature 'front page loads' do
  scenario 'user visits front page' do
    visit '/'
    expect(page.status_code) == '200'
    expect(page).not_to have_content('sorry')
    expect(page).to have_content('When your job involves hazardous material, having tools to make fast accurate decisions is paramount. Knowing where the incident occurred, where your personnel and response equipment are, and how fast can they be deployed, can make the difference between a manageable incident and an expensive catastrophe. We have tools to help.')
  end
  scenario 'user visits products page' do
    visit 'public/products'
    expect(page.status_code) == '200'
    expect(page).not_to have_content('sorry')
    expect(page).to have_content('The dedicated Mapping Platform was developed specifically to address the needs of the Marine Industry. Our Clients identified a variety of needs that would make their operations more efficient:')
  end
  scenario 'user visits services page' do
    visit 'public/services'
    expect(page.status_code) == '200'
    expect(page).not_to have_content('sorry')
    expect(page).to have_content('In addition to the Dedicated Mapping Platform product, we offer a service to define and develop custom overlays or custom vessel display information based on your unique requirements. For example, if you want to display an overlay showing your customers, vendors, facilities, or any other information, we can work with you to build that application. This overlay would only be visible on your site unless you wanted to share it with other partners.')
  end
  scenario 'user visits about page' do
    visit 'public/about'
    expect(page.status_code) == '200'
    expect(page).not_to have_content('sorry')
    expect(page).to have_content('Dedicated Maps has developed a proprietary web based mapping platform for the Marine and Aviation Industries. This platform, called the Dedicated Mapping Platform (tm) allows marine and aviation clients to track assets, both static and mobile, in real-real time to make better, timelier decisions.')
  end
  scenario 'user visits contact page' do
    visit 'public/contact'
    expect(page.status_code) == '200'
    expect(page).not_to have_content('sorry')
    expect(page).to have_content('To see a demo map, please login in above with the following credentials.')
  end
end