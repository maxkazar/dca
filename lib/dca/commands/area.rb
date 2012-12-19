module DCA
  module Commands
    class Area < Thor
      include Thor::Actions

      def self.source_root
        File.expand_path('../templates', __FILE__)
      end

      desc 'create NAME TITLE DESCRIPTION URL', 'Generate and add new area to project'
      long_desc <<-LONGDESC
        Generate and add a new area named <name> with to project. Parameters <name>, <title>, <description> and <url>
        are required
      LONGDESC
      def create name, title, description, url
        @name = name
        @class_name = name.camelize

        template 'area/analyzer.rb.erb', "lib/areas/#{name.downcase}/analyzer.rb"
        template 'area/position.rb.erb', "lib/areas/#{name.downcase}/models/position.rb"
        template 'area/page.rb.erb', "lib/areas/#{name.downcase}/models/page.rb"
        template 'area/models.rb.erb', "lib/areas/#{name.downcase}/models.rb"
        template 'area/area.rb.erb', "lib/areas/#{name.downcase}.rb"

        template 'spec/analyzer_spec.rb.erb', "spec/areas/#{name.downcase}/analyzer_spec.rb"
        template 'spec/spec_helper.rb.erb', "spec/areas/#{name.downcase}/spec_helper.rb"

        empty_directory 'config'
        area_file = 'config/areas.yml'
        areas = {}
        areas = YAML.load_file(area_file) if File.exist? area_file
        area_hash = {'title' => title, 'description' => description, 'url' => url}
        if areas.has_key? name
          if areas[name] == area_hash
            shell.say_status :identical, area_file, :blue
          else
            areas[name] = area_hash
            shell.say_status :conflict, area_file, :red
            if shell.file_collision(area_file) { areas.to_yaml }
              open(area_file, 'w:utf-8') { |file| file.write areas.to_yaml }
              shell.say_status :force, area_file, :yellow
            end
          end
        else
          status = areas.empty? ? :create : :update
          areas[name] = area_hash
          open(area_file, 'w:utf-8') { |file| file.write areas.to_yaml }
          shell.say_status status, area_file, :green
        end
      end

      desc 'start NAME', 'Start area to analyze'
      def start name = nil
        areas = name ? [name] : APP_CONFIG[:areas].keys
        areas.each { |name| start_area name.to_s }
      end

      desc 'stop NAME', 'Stop area to analyze'
      method_option :force, :type => :boolean, :aliases => '-f', :desc => 'force stop area analyzing process'
      def stop name = nil
        areas = name ? [name] : APP_CONFIG[:areas].keys
        areas.each { |name| stop_area name.to_s }
      end

      protected

      def start_area name
        shell.say "Starting analyze area #{name}"
        config = area_config name.to_sym

        job_ops = {}
        job_ops[:distributed] = true if config[:distributed]
        job = "#{DCA.project_name}::Areas::#{name}::AnalyzerJob".constantize
        puts job
        job.create job_ops

        background = config[:background].nil? ? true : config[:background]
        run_worker name, config[:workers] || 1, background
      end

      def stop_area name
        shell.say "Stopping analyze area #{name}"

        pids = workers_pids name
        unless pids.empty?
          shell.say "Find workers with pids #{pids.join(', ')}"
          `kill -s #{options[:force] ? 'QUIT' : 'TERM'} #{pids.join(' ')}`
        end

        wait_worker name

        Resque.remove_queue name
      end

      def area_config area_name
        config = APP_CONFIG[:areas][area_name] if APP_CONFIG[:areas]
        config || {}
      end

      def run_worker(queue, count = 1, background = true)
        puts "Starting #{count} worker(s) with QUEUE: #{queue}"
        unless background
          ENV['QUEUE'] = queue
          ENV['VERBOSE'] = '1' if APP_CONFIG[:verbose]
          ENV['TERM_CHILD'] = '1'
          ENV['RESQUE_TERM_TIMEOUT'] = RESQUE_TERM_TIMEOUT if defined? RESQUE_TERM_TIMEOUT
          Rake::Task['resque:work'].invoke
        else
          log_dir = File.join DCA.root, 'log'
          Dir.mkdir log_dir unless Dir.exist? log_dir
          ops = { :pgroup => true }
          if APP_CONFIG[:logger]
            debug_file = [File.join(DCA.root, "log/#{queue.underscore}.debug"), 'a']
            ops[:err] = debug_file
            ops[:out] = debug_file
          end
          env_vars = {'TERM_CHILD' => '1', 'QUEUE' => queue, 'SYS_ENV' => SYS_ENV}
          env_vars['RESQUE_TERM_TIMEOUT'] = RESQUE_TERM_TIMEOUT if defined? RESQUE_TERM_TIMEOUT
          env_vars['VERBOSE'] = '1' if APP_CONFIG[:verbose]
          count.times {
            ## Using Kernel.spawn and Process.detach because regular system() call would
            ## cause the processes to quit when capistrano finishes
            pid = spawn(env_vars, "rake resque:work", ops)
            Process.detach(pid)
          }
        end
      end

      def workers_pids name
        pids = []
        Resque.workers.each do |worker|
          host, pid, queues = worker.id.split(':')
          next unless host == worker.hostname

          queues = queues.split(',')
          next unless queues.include? name
          pids << pid
        end
        pids.uniq
      end

      def wait_worker name
        sleep 1 while workers_pids(name).count > 0
      end
    end
  end
end