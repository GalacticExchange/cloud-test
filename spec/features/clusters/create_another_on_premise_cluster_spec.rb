RSpec.describe "Testing main functionality ", :type => :request do

  describe "Create another cluster" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end
    # Need to specify environment variable: user_name and user_id
    it 'create another On-premise cluster'  do
      # log in ClusterGX
      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      find('input[name=commit]').click

      go_to_clusters_page

      create_cluster_button = find('button', :text => 'Create cluster').click

      create_on_premise_button.click
      create_on_premise_cluster_btn.click

      user_id = ENV['user_id'].to_i
      puts user_id

      cluster_created = wait_log_event("cluster_created", 60, {user_id: user_id})
      expect(cluster_created).not_to be_nil
      puts "Cluster created"

      cluster_id = cluster_created['cluster_id'].to_i
      puts "cluster id = #{cluster_id}"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"installed"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: installing ---> installed"

      cluster_installed = wait_log_event("cluster_installed", 60, {cluster_id: cluster_id})
      expect(cluster_installed ).not_to be_nil
      puts "Cluster was installed"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"active"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: installed ---> active"

    end
  end

end