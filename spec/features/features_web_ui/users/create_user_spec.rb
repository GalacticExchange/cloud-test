RSpec.describe "Create user ", :type => :request do

  describe "user" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end


    it "create user with site" do
      # create random user
      user_hash_post = build_user_hash_post

      puts "user: #{user_hash_post.inspect}"
      #
      visit Myconfig::HUB_HOST + 'users/new'

      # fill form
      registration_form = find('form#new_user')
      user_data = user_hash_post
      registration_form.fill_in 'user_email', :with => user_data[:email]
      registration_form.fill_in 'user_username', :with => user_data[:username]
      registration_form.fill_in 'user_team_attributes_name', :with => user_data[:teamname]
      registration_form.fill_in 'user_firstname', :with => user_data[:firstname]
      registration_form.fill_in 'user_lastname', :with => user_data[:lastname]
      registration_form.fill_in 'user_phone', :with => '+380570000000'

      registration_form.find('input[type=submit]').click

      #
      expect(current_path).to match /users\/created/


    end
  end

end