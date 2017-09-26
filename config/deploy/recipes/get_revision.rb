desc 'Show deployed revision'
namespace :deploy do
  task :revision do
    on roles(:app) do
      execute "tail -1 #{deploy_to}/revisions.log"
    end
  end
end
