RSpec.describe "Testing install app", :type => :request do

  describe "apps installation (zoomdata)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
      end
    after :each do
      sign_out
    end


    it 'zoomdata installation'  do

      # log in ClusterGX
      fill_in 'user_login', :with => 'emery' # ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster
      app_hub_tab.click
      zoomdata_install_link.click
      top_continue_button.click
      page.driver.browser.switch_to.window(pop_up)
      ok_button.click
      page.driver.browser.switch_to.window(main_window)

      installed_apps_tab.click

      cluster_id = 361 # ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      application_create = wait_log_event("application_create", 90, {cluster_id: cluster_id})
      expect(application_create).not_to be_nil
      puts "Event application create"

      vagrant_status = wait_log_event("vagrant_status", 180, {cluster_id: cluster_id})
      expect(vagrant_status).not_to be_nil
      puts "Vagrant status --->  command completed"

      application_install = wait_log_event("application_install", 360, {cluster_id: cluster_id})
      expect(application_install).not_to be_nil
      puts "Event: application install ---> 'vagrant install container' command completed"

      vagrant_status = wait_log_event("vagrant_status", 120, {cluster_id: cluster_id})
      expect(vagrant_status).not_to be_nil
      puts "Vagrant status --->  command completed"

      application_run = wait_log_event("application_run", 600, {cluster_id: cluster_id})
      expect(application_run).not_to be_nil
      puts "Event: application run ---> 'vagrant run container' command completed"


      installed_apps_tab.click
      find('[data-row="app-zoomdata"]').click
      app_state.should == 'active'
      sleep 3

      services_name, all_public_ip, all_port = [], [], []
      find_all('td[data-div="service-name"]').each do |x|
        service_name = x.text
        services_name << service_name
      end
      find_all('td[data-div="public_ip"]').each  do |y|
        public_ip = y.text
        all_public_ip << public_ip
      end
      find_all('td[data-div="port"]').each  do |z|
        port = z.text
        all_port << port
      end

      for i in 0...services_name.size
        for k in 1..15
          puts "#{services_name[i]}: telnet #{all_public_ip[i]} #{all_port[i]}"
          stdout, stdeerr, status = Open3.capture3("telnet #{all_public_ip[i]} #{all_port[i]}")
          if stdout =~ /Connected/
            puts "STDOUT: #{stdout}"
            break
          elsif stdout =~ /Trying/
            puts k
            sleep 60
            puts "STDOUT: #{stdout}" if k == 15
            fail "Failed to connect to service #{services_name[i]}" if k == 15
          else
            puts "STDOUT: #{stdout}"
            fail "Failed to connect to service #{services_name[i]}"
          end
        end
      end


    end


    it "test telnet" do

      fill_in 'user_login', :with => 'emery' # ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster
      installed_apps_tab.click
      find('[data-row="app-zoomdata"]').click
      app_state.should == 'active'
      sleep 3

      services_name, all_public_ip, all_port = [], [], []
      find_all('td[data-div="service-name"]').each do |x|
        service_name = x.text
        services_name << service_name
      end
      find_all('td[data-div="public_ip"]').each  do |y|
        public_ip = y.text
        all_public_ip << public_ip
      end
      find_all('td[data-div="port"]').each  do |z|
        port = z.text
        all_port << port
      end

      for i in 0...services_name.size
        for k in 1..15
          puts "#{services_name[i]}: telnet #{all_public_ip[i]} #{all_port[i]}"
          stdout, stdeerr, status = Open3.capture3("telnet #{all_public_ip[i]} #{all_port[i]}")
          if stdout =~ /Connected/
            puts "STDOUT: #{stdout}"
            break
          elsif stdout =~ /Trying/
            puts k
            sleep 60
            puts "STDOUT: #{stdout}" if k == 15
            fail "Failed to connect to service #{services_name[i]}" if k == 15
          else
            puts "STDOUT: #{stdout}"
            fail "Failed to connect to service #{services_name[i]}"
          end
        end
      end
    end
  end
end

