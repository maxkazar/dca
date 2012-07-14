module DCA
  class Notifier
    def self.create config
      @driver = "DCA::#{config[:driver]}Notifier".constantize.new config
    end

    def self.push object, event, options = {}
      @driver.push object, event, options unless @driver.nil?
    end
  end
end