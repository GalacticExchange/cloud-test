class Myconfig
  HUB_HOST = 'http://localhost:3000/'

  def self.config
    {
        gex_package: "gextest",
        redis_host: '51.1.10.21',
        redis_prefix: 'gex'
    }
  end

end
