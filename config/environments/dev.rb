class Myconfig
  HUB_HOST = 'http://devapi.gex/'

  def self.config
    {
        gex_package: "gextest",
        redis_host: 'devapi.gex',
        redis_prefix: 'gex',

    }
  end

end
