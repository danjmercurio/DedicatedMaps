describe User do
	it 'has a valid factory' do
	  expect(create(:user)).to be_valid
	end

	it 'requires a username' do
		expect(build(:user, username:nil)).to_not be_valid
	end

	it 'requires a first name' do
		expect(build(:user, first_name: nil)).to_not be_valid
	end

	it 'requires a last name' do
		expect(build(:user, last_name: nil)).to_not be_valid
	end

	it 'must have a username over 1 character' do
		expect(build(:user, username: "a")).to_not be_valid
	end

	it 'must have a username over 3 characters' do
		expect(build(:user, username: "aaa")).to_not be_valid
	end

	it 'must have a username under 40 characters' do
		expect(build(:user, username: "abcdefghijabcdefghijabcdefghijabcdefghij")).to_not be_valid
	end

	it 'must have a password' do
		expect { 
		    build(:user, password: nil) 
		  }.to raise_error(NoMethodError)
	end

	it 'must have a password over 3 characters' do
		expect(build(:user, password: "aaa")).to_not be_valid
	end

	it 'must have a password under 26 characters' do
		expect(build(:user, password: "aaaaaaaaaaaaaaaaaaaaaaaaaa")).to be_valid
	end

	it 'must not have a password over 26 characters' do 
		expect(build(:user, password: "aaaaaaaaaaaaaaaaaaaaaaaaaaa")).to_not be_valid
	end

	it 'must not accept spaces in passwords' do
		expect(build(:user, password: "asdsd aa")).to_not be_valid
		expect(build(:user, password: " asdsdaa")).to_not be_valid
		expect(build(:user, password: "asdsdaa a")).to_not be_valid
	end

	it 'email addresses must be unique' do
		expect(build(:user, email: "dhollerich@data-bridge-inc.com")).to_not be_valid
	end

	# it 'can remove all layers' do
	# 	@u = build(:user)
	# 	@u.remove_all_layers
	# 	expect(@u.layers.count).to_be 0
	# end
end