namespace :deploy do
  namespace :assets do
    namespace :precompile do
      task :if_changed do
        on roles(:app) do
          precompile_command = "cd #{release_path} && RAILS_ENV=#{fetch(:rails_env)} bundle exec rake assets:precompile"
          # precompile_command = "cd #{release_path} && bundle exec rake assets:precompile"
          logged_revision = capture("tail -1 #{deploy_to}/revisions.log") rescue ''
          puts "---------- #{logged_revision} #{logged_revision.class}"
          if logged_revision.length == 0
            execute precompile_command
            return
          end

          deployed_revision = logged_revision.match(/release (\d+)/).captures[0]

          has_differences = true
          %w(lib/assets app/assets vendor/assets Gemfile.lock config).each do |path|
            command = "diff --brief -r #{release_path}/#{path} #{deploy_to}/releases/#{deployed_revision}/#{path} || :"
            info "Running command: #{command}"
            differences = capture(command) rescue ''
            if differences.length > 0
              has_differences = true
              info "Differences found here... Running assets precompiling :'-("
              break
            end
          end

          if has_differences
            execute precompile_command
          else
            info "----- Skipping assets precompilation because there were no asset changes. yay!!! :-) -----"
          end
        end
      end

    end
  end

end