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
      create_on_premise_button.click
      create_on_premise_cluster_btn.click

      cluster_created = wait_log_event("cluster_created", 60, {user_id: user_id})
      expect(cluster_created).not_to be_nil
      puts "Cluster created"

      cluster_id = cluster_created['cluster_id']
      puts "CLUSTER_ID = #{cluster_id}"


      cluster_installed = wait_log_event("cluster_installed", 180, {cluster_id: cluster_id})
      expect(cluster_installed ).not_to be_nil
      puts "Cluster was installed"

      cluster_status_changed = wait_log_event("cluster_status_changed", 60, {cluster_id: cluster_id, to:"active"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: installed ---> active"
      sleep 5


      switch_to_cluster
      nodes_tab.click

      add_local_node_btn.click
      page.driver.browser.switch_to.window(pop_up)
      ok_button.click
      page.driver.browser.switch_to.window(main_window)
      nodes_tab.click


      node_installed = wait_log_event("node_installed", 90, {cluster_id: cluster_id})
      expect(node_installed).not_to be_nil
      puts "Event node installed"

      node_status_changed = wait_log_event("node_status_changed", 120, {from:"installing", to:"installed", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installing ---> installed"

      node_status_changed = wait_log_event("node_status_changed", 90, {from:"installed", to:"starting", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: installed ---> starting"

      vagrant_up = wait_log_event("vagrant_up", 480, {cluster_id: cluster_id})
      expect(vagrant_up).not_to be_nil
      puts "Vagrant up"

      node_status_changed = wait_log_event("node_status_changed", 60, {from:"starting", to:"active", cluster_id: cluster_id})
      expect(node_status_changed).not_to be_nil
      puts "Changed status: starting ---> active"

      nodes_tab.click

      sleep 5
      node_state.should == 'joined'
      status_checks.should == 'Passed'
    end
  end
  end