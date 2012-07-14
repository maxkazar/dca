require File.expand_path('../commands/area', __FILE__)

module DCA
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path('../commands/templates', __FILE__)
    end

    desc 'config', 'Create default config file'
    def config
      empty_directory 'config'
      template 'config.yml.erb', 'config/config.yml'
    end

    desc 'area SUBCOMMAND ...ARGS', 'Manage project areas'
    subcommand 'area', Commands::Area

    desc 'install', 'Install dca project'
    def install
      project = "#{DCA.project_name}::Project".constantize
      project.install
    end

    desc 'uninstall', 'Uninstall dca  project'
    def uninstall
      project = "#{DCA.project_name}::Project".constantize
      project.remove
    end
  end
end