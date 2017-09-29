RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (reinstall node)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    # Need to specify environment variable: user_name and cluster_id
    it 'reinstall node'  do
      # log in ClusterGX
      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster
      nodes_tab.click
      local_node.click

      settings_node_button.click
      reinstall_button.click
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

      node_installed = wait_log_event("node_installed", 90, {cluster_id: cluster_id})
      expect(node_installed).not_to be_nil
      puts "Event node installed"

      ok_button.click
      page.driver.browser.switch_to.window(main_window)

      node_status_changed = wait_log_event("node_status_changed", 120, {from:"installing", to:"installed", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installing ---> installed"

      node_status_changed = wait_log_event("node_status_changed", 90, {from:"installed", to:"starting", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installed ---> starting"

      vagrant_up = wait_log_event("vagrant_up", 360, {cluster_id: cluster_id})
      expect(vagrant_up).not_to be_nil
      puts "Vagrant up"

      node_status_changed = wait_log_event("node_status_changed", 60, {from:"starting", to:"active", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: starting ---> active"

      nodes_tab.click
      sleep 5

      node_state.should == 'joined'
      status_checks.should == 'passed'

    end
  end

end