RSpec.describe "Testing main functionality ", :type => :request do

  describe "Create new cluster" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end

    # Need to specify environment variable: user_name and user_id
    it 'create AWS cluster'  do
      # log in ClusterGX
      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      find('input[name=commit]').click

      create_aws_button.click
      fill_config_form_for_aws
      create_aws_cluster_btn.click

      user_id = ENV['user_id'].to_i
      puts user_id

      cluster_created = wait_log_event("cluster_created", 60, {user_id: user_id})
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


    end
  end

end