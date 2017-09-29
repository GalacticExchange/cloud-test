RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (remove)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      # sign out
      avatar_icon.click
      sign_out_button.click
      sign_out_message.should == "Signed out successfully."
    end

    it 'remove node'  do

      fill_in 'user_login', :with => 'jettie' # ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster

      cluster_id =  336 #ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"
      nodes_tab.click
      local_node.click
      settings_node_button.click
      remove_button.click

      page.driver.browser.switch_to.window(pop_up)
      yes_button.click
      ok_button.click
      page.driver.browser.switch_to.window(main_window)

      node_status_changed = wait_log_event("node_status_changed", 60, {from: "active", to:"removing", cluster_id: cluster_id})
      expect(node_status_changed).no_to be_nil
      puts "Node status changed: active ---> removing"

      node_status_changed = wait_log_event("node_status_changed", 60, {from: "active", to:"removed", cluster_id: cluster_id})
      expect(node_status_changed).no_to be_nil
      puts "Node status changed: active ---> removed"

      nodes_tab.click

      node_state.should == 'removed'

      stats_tab.click
      text = first('.text-center').text.should == 'Looks like you do not have any nodes in this cluster.'

    end
    end
end