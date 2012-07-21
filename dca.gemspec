# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dca"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Maxim Kazarin"]
  s.date = "2012-07-21"
  s.description = "DCA"
  s.email = "maxkazargm@gmail.com"
  s.executables = ["dca"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/dca",
    "dca.gemspec",
    "lib/dca.rb",
    "lib/dca/cli.rb",
    "lib/dca/commands/area.rb",
    "lib/dca/commands/templates/area/analyzer.rb.erb",
    "lib/dca/commands/templates/area/area.rb.erb",
    "lib/dca/commands/templates/area/models.rb.erb",
    "lib/dca/commands/templates/area/page.rb.erb",
    "lib/dca/commands/templates/area/position.rb.erb",
    "lib/dca/commands/templates/config.yml.erb",
    "lib/dca/commands/templates/spec/analyzer_spec.rb.erb",
    "lib/dca/commands/templates/spec/spec_helper.rb.erb",
    "lib/dca/config.rb",
    "lib/dca/helpers.rb",
    "lib/dca/helpers/logger.rb",
    "lib/dca/jobs.rb",
    "lib/dca/jobs/analyzer_job.rb",
    "lib/dca/jobs/job.rb",
    "lib/dca/models.rb",
    "lib/dca/models/base_model.rb",
    "lib/dca/models/binder.rb",
    "lib/dca/models/binder_helper.rb",
    "lib/dca/models/nokogiri_binder.rb",
    "lib/dca/models/position.rb",
    "lib/dca/net.rb",
    "lib/dca/net/browser_helper.rb",
    "lib/dca/notifier.rb",
    "lib/dca/notifier/notifier.rb",
    "lib/dca/notifier/redis/models/analyze_notify.rb",
    "lib/dca/notifier/redis/models/failure_notify.rb",
    "lib/dca/notifier/redis/models/fetch_notify.rb",
    "lib/dca/notifier/redis/models/session.rb",
    "lib/dca/notifier/redis/notifier.rb",
    "lib/dca/notifier/redis_notifier.rb",
    "lib/dca/storage.rb",
    "lib/dca/storage/elasticsearch_storage.rb",
    "lib/dca/storage/mongo_storage.rb",
    "lib/dca/storage/storage.rb",
    "spec/analyzer_spec.rb",
    "spec/area_task_spec.rb",
    "spec/base_model_spec.rb",
    "spec/binder_spec.rb",
    "spec/config.yml",
    "spec/elasticsearch_storage_spec.rb",
    "spec/fixtures/page.html",
    "spec/fixtures/positions.yml",
    "spec/fixtures/positions_with_error.yml",
    "spec/fixtures/states.yml",
    "spec/job_spec.rb",
    "spec/mock/analyzer_job.rb",
    "spec/mock/file_storage.rb",
    "spec/mock/notify_object.rb",
    "spec/mock/page.rb",
    "spec/mock/position.rb",
    "spec/mock/web_notifier.rb",
    "spec/mongo_storage_spec.rb",
    "spec/redis_notifier_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/storage_examples.rb"
  ]
  s.homepage = "http://github.com/maxkazargm@gmail.com/dca"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "DCA"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ohm>, [">= 0"])
      s.add_runtime_dependency(%q<activemodel>, [">= 0"])
      s.add_runtime_dependency(%q<resque>, [">= 0"])
      s.add_runtime_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_runtime_dependency(%q<tire>, [">= 0"])
      s.add_runtime_dependency(%q<uuid>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_runtime_dependency(%q<mongo>, [">= 0"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 0"])
      s.add_development_dependency(%q<mock_redis>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<guard-rspec>, [">= 0"])
      s.add_development_dependency(%q<libnotify>, [">= 0"])
    else
      s.add_dependency(%q<ohm>, [">= 0"])
      s.add_dependency(%q<activemodel>, [">= 0"])
      s.add_dependency(%q<resque>, [">= 0"])
      s.add_dependency(%q<yajl-ruby>, [">= 0"])
      s.add_dependency(%q<tire>, [">= 0"])
      s.add_dependency(%q<uuid>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<mongo>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<mock_redis>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<guard-rspec>, [">= 0"])
      s.add_dependency(%q<libnotify>, [">= 0"])
    end
  else
    s.add_dependency(%q<ohm>, [">= 0"])
    s.add_dependency(%q<activemodel>, [">= 0"])
    s.add_dependency(%q<resque>, [">= 0"])
    s.add_dependency(%q<yajl-ruby>, [">= 0"])
    s.add_dependency(%q<tire>, [">= 0"])
    s.add_dependency(%q<uuid>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<mongo>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<mock_redis>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<guard-rspec>, [">= 0"])
    s.add_dependency(%q<libnotify>, [">= 0"])
  end
end

