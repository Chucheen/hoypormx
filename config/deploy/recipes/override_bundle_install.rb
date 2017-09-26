namespace :bundler do
  namespace :install do
    task :if_changed do
      on roles(:app) do
        # Due to a wrong
        # FUCKED UP environments
        fu_environments = ['production', 'staging2', :production, :staging2]
        # bundle_command = "cd #{release_path} && RAILS_ENV=#{fetch(:rails_env)} /usr/local/rvm/bin/rvm default do bundle install --path #{fetch(:deploy_to)}/shared/bundle --without development test --deployment --quiet --full-index"
        # bundle_command = "cd #{release_path} && RAILS_ENV=#{fetch(:rails_env)} bundle install --path #{fetch(:deploy_to)}/shared/bundle --without development test --deployment --quiet --full-index"
        # bundle_command = "cd #{release_path} && /usr/local/rvm/bin/rvm default do bundle install --path #{fetch(:deploy_to)}/shared/bundle --without development test --deployment --quiet"





        # bundle_command = "cd #{release_path} && /usr/local/rvm/bin/rvm default do bundle install --path #{fetch(:deploy_to)}/shared/bundle --without development test --deployment --quiet"
        # bundle_command = "cd #{release_path} && bundle install" if fetch(:rails_env) == 'production' || fetch(:rails_env) == :production

        bundle_command = "cd #{release_path} && bundle install --path /export/homie/shared/bundle --without development test --deployment --quiet"


        logged_revision = capture("tail -1 #{deploy_to}/revisions.log") rescue ''
        puts "---------- #{logged_revision} #{logged_revision.class}"
        if logged_revision.length == 0 || true
          execute bundle_command
        else
          deployed_revision = logged_revision.match(/as release (\d+)/).captures[0]
          has_differences = false
          %w(Gemfile Gemfile.lock).each do |path|
            command = "diff --brief -r #{release_path}/#{path} #{deploy_to}/releases/#{deployed_revision}/#{path} || :"
            info "Running command: #{command}"
            differences = capture(command) rescue ''
            if differences.length > 0
              has_differences = true
              info "  Differences found here... Running bundle install :'-("
              break
            end
          end
          if has_differences
            execute bundle_command
          else
            info "----- Skipping bundle install because there were no gem changes. yay!!! :-) -----"
          end
        end
      end
    end
  end
end