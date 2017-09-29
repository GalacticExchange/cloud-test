RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (remove and force uninstall)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    it 'force uninstall node'  do

      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      nodes_tab.click
      sleep 5

      node_state.should == 'removed'
      local_node.click

      force_uninstall_button.click
      page.driver.browser.switch_to.window(pop_up)
      yes_button.click

      node_uninstall_stop_box = wait_log_event("node_uninstall_stop_box", 90, {cluster_id: cluster_id})
      expect(node_uninstall_stop_box).not_to be_nil
      puts "Node uninstall  stop  box"

      node_uninstall_remove_box = wait_log_event("node_uninstall_remove_box", 60, {cluster_id: cluster_id})
      expect(node_uninstall_remove_box).not_to be_nil
      puts "Node uninstall remove box"

      node_uninstall_remove_config_files = wait_log_event("node_uninstall_remove_config_files", 60, {cluster_id: cluster_id})
      expect(node_uninstall_remove_config_files).not_to be_nil
      puts "Node uninstall remove config file"

      ok_button.click

      page.driver.browser.switch_to.window(main_window)
      nodes_tab.click

      text = first('.text-center.marg_left_big').text.should == 'Looks like you do not have any nodes in this cluster.'

    end
    end
end