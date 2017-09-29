RSpec.describe "Complex test ", :type => :request do

  describe "add local node" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    it "full cycle of adding local node" do
      # create random user
      user_hash_post = build_user_hash_post
      puts "user: #{user_hash_post.inspect}"
      sign_up_link.click
      # registration
      user_data = user_hash_post
      registration_form.fill_in 'user_email', :with => user_data[:email]
      registration_form.fill_in 'user_username', :with => user_data[:username]
      registration_form.fill_in 'user_team_attributes_name', :with => user_data[:teamname]
      registration_form.fill_in 'user_firstname', :with => user_data[:firstname]
      registration_form.fill_in 'user_lastname', :with => user_data[:lastname]
      registration_form.fill_in 'user_phone', :with => '+380570000000'
      sign_up_button.click

      first('h1.text-center').text.should == 'WELCOME TO GALACTIC EXCHANGE BETA PROGRAM!'
      first('h5.white').text.should == 'Check your email for further instructions.'

      user_created = wait_log_event("user_created", 60, {username: user_data[:username]})
      expect(user_created).not_to be_nil
      puts "User was created"

      user_id = user_created['user_id'].to_i
      puts "USER_ID = #{user_id}"

      sign_in_button.click

      # user login
      fill_in 'user_login', :with => user_data[:username]
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      title = find('.sidebar-header')
      title.find('h2').text.should == 'Create cluster'
      title.find('p').text.should == 'Step 1: Choose the type of your cluster.'

      # create cluster
      create_aws_button.click
      fill_config_form_for_aws
      create_aws_cluster_btn.click

      cluster_created = wait_log_event("cluster_created", 60, {user_id: user_id})
      expect(cluster_created).not_to be_nil
      puts "Cluster created"

      cluster_id = cluster_created['cluster_id'].to_i
      puts "cluster id = #{cluster_id}"

      cluster_created = wait_log_event("cluster_created", 90, {user_id: user_id})
      expect(cluster_created).not_to be_nil
      puts "Cluster created"

      cluster_id = cluster_created['cluster_id'].to_i
      puts "cluster id = #{cluster_id}"

      hadoop_install_start = wait_log_event("hadoop_install_start", 90, {cluster_id: cluster_id})
      expect(hadoop_install_start).no_to be_nil
      puts "Hadoop install start"

      cluster_create_provision_start = wait_log_event("cluster_create_provision_start", 90, {cluster_id: cluster_id})
      expect(cluster_create_provision_start).no_to be_nil
      puts "Cluster create provision start"

      cluster_create_ansible_start = wait_log_event("cluster_create_ansible_start", 90, {cluster_id: cluster_id})
      expect(cluster_create_ansible_start).no_to be_nil
      puts "Cluster create ansible start"

      cluster_status_changed = wait_log_event("cluster_status_changed", 480, {cluster_id: cluster_id, to:"installed"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: installing ---> installed"

      cluster_installed = wait_log_event("cluster_installed", 30, {cluster_id: cluster_id})
      expect(cluster_installed ).not_to be_nil
      puts "Cluster was installed"

      cluster_status_changed = wait_log_event("cluster_status_changed", 60, {cluster_id: cluster_id, to:"active"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: installed ---> active"
      logotype.click
      nodes_tab.click

      add_local_node_btn.click
      page.driver.browser.switch_to.window(pop_up)
      ok_button.click
      page.driver.browser.switch_to.window(main_window)
      nodes_tab.click

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