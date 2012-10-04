require 'yaml'
require 'active_model'
require 'rake'
require 'resque'
require 'resque/tasks'
require 'ohm'
require 'uuid'
require 'yajl/json_gem'
require 'tire'
require 'logger'
require 'thor'
require 'thor/group'
require 'nokogiri'
require 'mongo'

module DCA
  class ApplicationError < Exception; end

  def self.root
    Dir.pwd
  end

  def self.used?
    File.basename(self.root).downcase != 'dca'
  end

  def self.project_name
    return @project if @project.present?

    gemspec = Dir[File.join self.root, '*.gemspec'].first
    raise 'Generate gemspec file' if gemspec.blank?

    gem = Gem::Specification.load gemspec
    raise 'Set gem name in gemspec'  if gem.name.blank?

    @project = gem.name.camelize
    if @project.safe_constantize.nil?
      @project = (Object.constants.detect { |const|
        const.to_s.downcase == @project.downcase}).to_s
      raise "Unknown project name" if @project.nil?
    end

    @project
  end

  def self.project_path
    @project_path ||= File.join(DCA.root, 'lib', File.basename(DCA.root))
  end

  def self.project_file
    @project_path ||= project_path + '.rb'
  end
end

require File.expand_path('../dca/config', __FILE__)
require File.expand_path('../dca/helpers', __FILE__)
require File.expand_path('../dca/storage', __FILE__)
require File.expand_path('../dca/jobs', __FILE__)
require File.expand_path('../dca/net', __FILE__)
require File.expand_path('../dca/notifier', __FILE__)
require File.expand_path('../dca/models', __FILE__)
require File.expand_path('../dca/cli', __FILE__)

Resque.redis = "#{APP_CONFIG[:redis][:host]||'localhost'}:#{APP_CONFIG[:redis][:port]||'6379'}" if APP_CONFIG[:redis]

require DCA.project_path if DCA.used? && File.exist?(DCA.project_file)
