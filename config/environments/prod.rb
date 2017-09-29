class Myconfig
  HUB_HOST = 'http://api.galacticexchange.io/'

  def self.config
    {
        gex_package: "gex",
        #redis_host: 'api.galacticexchange.io',
        redis_host: '10.1.0.12',
        redis_prefix: 'gex'
    }
  end

end
