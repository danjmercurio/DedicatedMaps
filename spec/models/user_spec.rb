describe User do
  it 'Has a valid factory' do
	  expect(create(:user)).to be_valid
	end

  it 'Requires a username' do
		expect(build(:user, username:nil)).to_not be_valid
	end

  it 'Requires a first name' do
		expect(build(:user, first_name: nil)).to_not be_valid
	end

  it 'Requires a last name' do
		expect(build(:user, last_name: nil)).to_not be_valid
	end

  it 'Must have a username over 1 character' do
    expect(build(:user, :username => "a")).to_not be_valid
	end

  it 'Must have a username over 3 characters' do
    expect(build(:user, :username => "aaa")).to_not be_valid
	end

  it 'Must have a username under 40 characters' do
    expect(build(:user, :username => "abcdefghijabcdefghijabcdefghijabcdefghij")).to_not be_valid
	end

  it 'Must have a password' do
		expect {
      build(:user, :password => nil)
		  }.to raise_error(NoMethodError)
	end

  it 'Must have a password over 3 characters' do
    expect(build(:user, :password => "aaa")).to_not be_valid
	end

  it 'Must have a password under 26 characters' do
    expect(build(:user, :password => 'aaaaaaaaaaaaaaaaaaaaaaaaaa')).to be_valid
	end

  it 'Must not have a password over 26 characters' do
    expect(build(:user, password: 'aaaaaaaaaaaaaaaaaaaaaaaaaaa')).to_not be_valid
	end

  it 'Does not accept spaces in passwords' do
    expect(build(:user, :password => 'asdsd aa')).to_not be_valid
    expect(build(:user, :password => ' asdsdaa')).to_not be_valid
    expect(build(:user, :password => "asdsdaa a")).to_not be_valid
    expect(build(:user, :password => " asdsdaaa")).to_not be_valid
	end

  it 'Does not accept email addresses that are not unique to the database' do
    create(:user, :email => 'somebody@somewhere.com')
    expect(build(:user, :email => 'somebody@somewhere.com').valid?).to eq(false)
  end

	# it 'can remove all layers' do
	# 	@u = build(:user)
	# 	@u.remove_all_layers
	# 	expect(@u.layers.count).to_be 0
	# end
end