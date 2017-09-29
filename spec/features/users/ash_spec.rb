RSpec.describe "Login user ", :type => :request do

  describe "login" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    it 'user login'  do


      # user login
      fill_in 'user_login', :with => "rubye"
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      @driver.take_screenshot("/tmp/ash2.png")
      # page.driver.browser.save_screenshot ("./ash1.png")
      login_button.click

      title = find('[data-div="page-title"]')
      title.find('h2').text.should == 'Create cluster'
      title.find('p').text.should == 'Step 1: Choose the type of your cluster.'

    end

  end


end

