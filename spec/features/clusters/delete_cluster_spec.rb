RSpec.describe "Testing main functionality ", :type => :request do

  describe "Create new cluster" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end
    # Need to specify environment variable: user_name and cluster_id
    it 'delete cluster'  do

      # log in ClusterGX
      fill_in 'user_login', :with => ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      find('input[name=commit]').click

      go_to_clusters_page
      delete_cluster_on_clusters_page
      yes_button.click

      cluster_id = ENV['cluster_id'].to_i
      puts "CLUSTER_ID = #{cluster_id}"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"uninstalling"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed: ---> to uninstalling"

      hadoop_uninstall_start = wait_log_event("hadoop_uninstall_start", 90, {cluster_id: cluster_id})
      expect(hadoop_uninstall_start).not_to be_nil
      puts "Hadoop uninstall start"

      hadoop_uninstalled = wait_log_event("hadoop_uninstalled", 90, {cluster_id: cluster_id})
      expect(hadoop_uninstalled).not_to be_nil
      puts "Hadoop uninstalled"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"uninstalled"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed:  --->  to uninstalled"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"removing"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed:  --->  to removing"

      cluster_status_changed = wait_log_event("cluster_status_changed", 90, {cluster_id: cluster_id, to:"removed"})
      expect(cluster_status_changed).not_to be_nil
      puts "Cluster status changed:  --->  to removed"


    end
  end

end