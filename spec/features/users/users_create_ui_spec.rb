RSpec.describe "Create user ", :type => :request do

  describe "user" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    it "create user" do
      # create random user
      user_hash_post = build_user_hash_post
      puts "user: #{user_hash_post.inspect}"
      sign_up_link.click
      # fill form
      user_data = user_hash_post
      registration_form.fill_in 'user_email', :with => user_data[:email]
      registration_form.fill_in 'user_username', :with => user_data[:username]
      registration_form.fill_in 'user_team_attributes_name', :with => user_data[:teamname]
      registration_form.fill_in 'user_firstname', :with => user_data[:firstname]
      registration_form.fill_in 'user_lastname', :with => user_data[:lastname]
      registration_form.fill_in 'user_phone', :with => '+380570000000'
      sign_up_button.click

      user_email = user_data[:email]
      puts user_email

      welcome_text = first('h1.text-center').text.should == 'WELCOME TO GALACTIC EXCHANGE BETA PROGRAM!'
      instruction_text = first('h5.white').text.should == 'Check your email for further instructions.'

      user_created = wait_log_event('user_created', 60, {username: user_data[:username]})
      expect(user_created).not_to be_nil
      puts "User was created"
      user_id_in_logs = user_created['user_id']
      puts "user id = #{user_id_in_logs}"

      # navigates to "Sign In" page
      sign_in_button.click

      # user login
      fill_in 'user_login', :with => user_data[:username]
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      title = find('[data-div="page-title"]')
      title.find('h2').text.should == 'Create cluster'
      title.find('p').text.should == 'Step 1: Choose the type of your cluster.'

    end
  end

end



