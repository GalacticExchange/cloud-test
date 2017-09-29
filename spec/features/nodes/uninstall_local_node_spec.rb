RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (uninstall node)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    # Need to specify environment variable: user_name and cluster_id

    it 'uninstall node'  do

      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster
      nodes_tab.click
      local_node.click
      settings_node_button.click
      uninstall_button.click
      page.driver.browser.switch_to.window(pop_up)
      yes_button.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      node_status_changed = wait_log_event("node_status_changed", 90, {from: "active", to:"uninstalling", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: active ---> uninstalling"

      stop_box_event = wait_log_event("node_uninstall_stop_box", 90, {cluster_id: cluster_id})
      expect(stop_box_event).not_to be_nil
      puts "Stop box"

      remove_box_event = wait_log_event("node_uninstall_remove_box", 60, {cluster_id: cluster_id})
      expect(remove_box_event).not_to be_nil
      puts "Remove box"

      remove_config_files = wait_log_event("node_uninstall_remove_config_files", 60, {cluster_id: cluster_id})
      expect(remove_config_files).not_to be_nil
      puts "Remove config_files"

      node_status_changed = wait_log_event("node_status_changed", 90, {from: "uninstalling", to:"uninstalled", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: uninstalling ---> uninstalled"

      node_status_changed = wait_log_event("node_status_changed", 90, {from: "uninstalled", to:"removing", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: uninstalled ---> removing"

      node_status_changed = wait_log_event("node_status_changed", 90, {from: "removing", to:"removed", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "chage status removing ---> removed"

      ok_button.click
      page.driver.browser.switch_to.window(main_window)
      stats_tab.click
      sleep 5

      text = first('h2.text-center').text.should == 'Looks like you do not have any nodes in this cluster.'

    end
  end
end