RSpec.describe "Testing main functionality ", :type => :request do

  describe "Node statistics" do
    before :each do
      TestEmailRedis::Helpers.clean_emails_all
    end
    after :each do
      sign_out
    end
    # Need to specify environment variable: user_name and node_uid
    it 'node statistics'  do

      fill_in 'user_login', :with => 'emery' # ENV['user_name']
      fill_in 'user_password', :with => 'PH_GEX_PASSWD1'
      login_button.click

      token = api_auth('emery', 'PH_GEX_PASSWD1')
      puts "TOKEN = #{token}"

       switch_to_cluster

      go_to_stats_node_page

      node_uid = "1702719125600032" # ENV['node_uid']

      array1 = api_do_request :get, "stats/nodes_history/#{node_uid}/metrics_memory", {}, {'token' => token}

      array2 = api_do_request :get, "stats/nodes_history/#{node_uid}/metrics_cpu", {}, {'token' => token}

      metrics_cpu = array2[1]
      metrics_memory = array1[1]
      diff_mem = 0
      diff_cpu = 0

      if array1[0].to_s == 'true'  && metrics_memory.size == 121
        date = Time.parse(metrics_cpu[120][0])
        time_now = Time.now()
        diff_mem = (time_now.to_i - date.to_i)
        puts "difference (memory dot) = #{diff_mem}"
      end

      if array2[0].to_s == 'true' && metrics_cpu.size == 121
          date = Time.parse(metrics_cpu[120][0])
          time_now = Time.now()
          diff_cpu = (time_now.to_i - date.to_i)
          puts "difference (cpu dot) = #{diff_cpu}"
      end

      fail ("Node statistics is frozen.") if diff_cpu > 130 || diff_mem > 130
    end
  end
end
