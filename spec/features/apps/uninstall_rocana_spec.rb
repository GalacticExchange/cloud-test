RSpec.describe "Testing uninstall app", :type => :request do

  describe "uninstall app(rocana)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end


    it 'uninstall rocana'  do

      # log in ClusterGX
      fill_in 'user_login', :with => 'jettie' # ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster
      app_hub_tab.click

      rocana_open_link.click
      settings_app_button.click

      cluster_id = 336 # ENV['cluster_id'].to_s
      puts "CLUSTER_ID = #{cluster_id}"

      uninstall_app_button.click

      page.driver.browser.switch_to.window(pop_up)
      yes_button.click
      page.driver.browser.switch_to.window(main_window)

      vagrant_status= wait_log_event("vagrant_status", 90, {cluster_id: cluster_id})
      expect(vagrant_status).not_to be_nil
      puts "'Vagrant status' command completed."

      application_uninstall= wait_log_event("application_uninstall", 90, {cluster_id: cluster_id})
      expect(application_uninstall).not_to be_nil
      puts "'Application uninstall: 'Vagrant uninstall container' command complited."

      installed_apps_tab.click
      sleep 3

      text_block = find('[ng-if="loaded && isAppsEmpty"]')
      text = text_block.find('h2').text.should == "Looks like you do not have any apps yet"

    end
  end

end