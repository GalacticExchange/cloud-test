RSpec.describe "Testing node management ", :type => :request do

  describe "nodes management" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    it 'stop node'  do
      # log in ClusterGX

      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster

      nodes_tab.click
      local_node.click
      sleep 5

      node_state.should == 'joined'
      status_checks.should == 'passed'
      stop_button.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      node_status_changed = wait_log_event("node_status_changed", 30, {from:"active", to:"stopping", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "changed status: active --> stopping"

      node_state.should == 'stopping'

      vagrant_halt = wait_log_event("vagrant_halt", 90, {cluster_id: cluster_id})
      expect(vagrant_halt).not_to be_nil
      puts "vagrant_halt"

      node_status_changed = wait_log_event("node_status_changed", 90, {from:"stopping", to:"stopped", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "changed status: stopping --> stopped"

      nodes_tab.click
      sleep 5

      node_state.should == 'stopped'
    end


    it 'start node'  do
      # log in ClusterGX
      fill_in 'user_login', :with =>  ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster

      nodes_tab.click
      local_node.click
      sleep 5

      node_state.should == 'stopped'
      start_button.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      node_status_changed = wait_log_event("node_status_changed", 60, {from:"stopped", to:"starting", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "changed status: stopped ---> starting"
      sleep 5

      node_state.should == 'starting'

      vagrant_up = wait_log_event("vagrant_up", 90, {cluster_id: cluster_id})
      expect(vagrant_up).not_to be_nil
      puts "vagrant_up"

      node_status_changed = wait_log_event("node_status_changed", 240, {from:"starting", to:"active", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "changed status: starting ---> active"

      nodes_tab.click
      local_node.click
      sleep 5

      node_state.should == 'joined'
      status_checks.should == 'passed'

    end


    it 'restart node'  do
      # log in ClusterGX
      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      switch_to_cluster

      nodes_tab.click
      local_node.click
      sleep 5

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"


      if (node_state.should == 'joined' || node_state.should == 'stopped')

        restart_button.click

        node_status_changed = wait_log_event("node_status_changed", 60, {to:"restarting", cluster_id: cluster_id})
        expect(node_status_changed).not_to be_nil
        puts "changed status to ---> restarting"

        node_state.should == 'restarting'

        vagrant_reload_halt = wait_log_event("vagrant_reload_halt", 180, {cluster_id: cluster_id})
        expect(vagrant_reload_halt).not_to be_nil
        puts "vagrant_reload_halt"

        vagrant_reload_up = wait_log_event("vagrant_reload_up", 180, {cluster_id: cluster_id})
        expect(vagrant_reload_up).not_to be_nil
        puts "vagrant_reload_up"

        node_status_changed = wait_log_event("node_status_changed", 120, {from: "restarting", to:"active", cluster_id: cluster_id})
        expect(node_status_changed).not_to be_nil
        puts "changed status: restarting ---> active"

        nodes_tab.click
        local_node.click
        sleep 5

        node_state.should == 'joined'
        status_checks.should == 'passed'
      else
        puts "Incorrect condition"
        fail
      end


    end
  end
end