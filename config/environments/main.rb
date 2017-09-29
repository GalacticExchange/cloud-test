class Myconfig
  HUB_HOST = 'http://api.gex/'

  def self.config
    {
        gex_package: "gextest",
        redis_host: 'api.gex',
        redis_prefix: 'gex',
        kafka_server: "51.1.12.92",
        kafka_port: "19092", #19092",
        kafka_topic: "log_app"
    }
  end
end
