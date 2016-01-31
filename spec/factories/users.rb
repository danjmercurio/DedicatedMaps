FactoryGirl.define do |variable|
	factory :user do
		username "newTestUser5000"
		email "fake@wooemail.com"
		first_name "tester"
		password "password123456"
		last_name "greatest"
		active true
		eula true
		time_zone "Pacific Time (US & Canada)"
		client_id 1
		salt "ijMNTr2JdMSF"
	end
end
