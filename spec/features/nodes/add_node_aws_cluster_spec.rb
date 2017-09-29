RSpec.describe "Testing main functionality ", :type => :request do

  describe "nodes main functionality (add node)" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    # Need to specify environment variable: user_name and cluster_id (Edit coniguration -> environment variable -> add)
    it 'add local node'  do

      fill_in('user_login', :with => ENV['user_name'])
      fill_in('user_password', :with => 'PH_GEX_PASSWD1')
      login_button.click

      nodes_tab.click

      add_aws_node_btn.click
      page.driver.browser.switch_to.window(pop_up)
      add_nodes_btn.click
      ok_button.click
      page.driver.browser.switch_to.window(main_window)

      nodes_tab.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      node_creating = wait_log_event("node_creating", 120, {cluster_id: cluster_id})
      expect(node_creating).not_to be_nil
      puts "Event node creating"

      node_created = wait_log_event("node_created", 120, {cluster_id: cluster_id})
      expect(node_created).not_to be_nil
      puts "Event node created"

      node_master_installing = wait_log_event("node_master_installing", 120, {cluster_id: cluster_id})
      expect(node_master_installing).not_to be_nil
      puts "Node master installing"

      hadoop_provision_start = wait_log_event("hadoop_provision_start", 120, {cluster_id: cluster_id})
      expect(hadoop_provision_start).not_to be_nil
      puts "Hadoop provision start"

      hadoop_provision_result = wait_log_event("hadoop_provision_result", 120, {cluster_id: cluster_id})
      expect(hadoop_provision_result).not_to be_nil
      puts "Hadoop provision result"

      node_aws_installing = wait_log_event("node_aws_installing", 120, {cluster_id: cluster_id})
      expect(node_aws_installing).not_to be_nil
      puts "Node aws installing"

      node_aws_install_result = wait_log_event("node_aws_install_result", 600, {cluster_id: cluster_id})
      expect(node_aws_install_result).not_to be_nil
      puts "Node aws install result"

      nodes_tab.click

      local_node.click
      sleep 5

      node_state.should == 'joined'
      status_checks.should == 'Passed'
    end

  end

end