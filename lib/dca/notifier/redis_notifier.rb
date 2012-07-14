require File.expand_path('../redis/models/failure_notify', __FILE__)
require File.expand_path('../redis/models/analyze_notify', __FILE__)
require File.expand_path('../redis/models/fetch_notify', __FILE__)
require File.expand_path('../redis/models/session', __FILE__)
require File.expand_path('../redis/notifier', __FILE__)

module DCA
  class RedisNotifier < Redis::Notifier; end
end