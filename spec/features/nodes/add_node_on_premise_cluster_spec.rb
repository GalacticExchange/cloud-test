RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (add node)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all

    end
    after :each do
      sign_out
    end


    # Need to specify environment variable: user_name and cluster_id
    it 'add local node on-premise cluster'  do

      fill_in('user_login', :with => ENV['user_name'])
      fill_in('user_password', :with => 'PH_GEX_PASSWD1')
      login_button.click

      switch_to_cluster
      nodes_tab.click

      add_local_node_btn.click
      page.driver.browser.switch_to.window(pop_up)

      ok_button.click
      page.driver.browser.switch_to.window(main_window)

      nodes_tab.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      hadoop_provision_start = wait_log_event("hadoop_provision_start"), 90, {cluster_id: cluster_id}
      expect(hadoop_provision_start).not_to be_nil
      puts "Hadoop provision start"

      hadoop_provision_result = wait_log_event("hadoop_provision_result"), 180, {cluster_id: cluster_id}
      expect(hadoop_provision_result).not_to be_nil
      puts "Hadoop provision result"

      node_installed = wait_log_event("node_installed", 360, {cluster_id: cluster_id})
      expect(node_installed).not_to be_nil
      puts "Event node installed"

      node_status_changed = wait_log_event("node_status_changed", 120, {from:"installing", to:"installed", cluster_id: cluster_id })
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installing ---> installed"

      node_status_changed = wait_log_event("node_status_changed", 120, {from:"installed", to:"starting", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installed ---> starting"

      node_uid = node_status_changed['node_uid']
      puts "NODE_UID = #{node_uid}"

      vagrant_up = wait_log_event("vagrant_up", 480, {cluster_id: cluster_id})
      expect(vagrant_up).not_to be_nil
      puts "Vagrant up"

      node_status_changed = wait_log_event("node_status_changed", 120, {from:"starting", to:"active", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: starting ---> active"

      nodes_tab.click
      sleep 5

      node_state.should == 'joined'

      status_checks.should == 'passed'
    end


  end

end