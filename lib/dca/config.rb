SYS_ENV = 'development' unless defined? SYS_ENV

unless defined? APP_CONFIG
  if File.exist? './config/config.yml'
    APP_CONFIG = YAML.load_file('./config/config.yml')[SYS_ENV].deep_symbolize_keys
  else
    APP_CONFIG = {}
    puts 'WARNING! Missing config file. Use rake system:config to create default config file.' if DCA.used?
  end
end

unless defined? AREA_CONFIG
  if APP_CONFIG[:areas]
    AREA_CONFIG = APP_CONFIG[:areas][ENV['QUEUE']]
  else
    AREA_CONFIG = {}
  end
end


