# frozen_string_literal: true

namespace :systemd do
  desc "Reload systemd user daemon"
  task :daemon_reload do
    on roles(:app) do
      execute :systemctl, "--user", "daemon-reload"
      execute :chmod, "+x", "/var/www/dummy_app/current/lib/capistrano/tasks/*.sh"
    end
  end

  desc "Enable all systemd user services"
  task :enable_all do
    on roles(:app) do
      execute "/var/www/dummy_app/current/lib/capistrano/tasks/systemd_enable_script.sh"
    end
  end

  desc "Start all systemd user services"
  task :start_all do
    on roles(:app) do
      execute "/var/www/dummy_app/current/lib/capistrano/tasks/systemd_start_script.sh"
    end
  end

  desc "Stop all systemd user services"
  task :stop_all do
    on roles(:app) do
      execute "/var/www/dummy_app/current/lib/capistrano/tasks/systemd_stop_script.sh"
    end
  end

  desc "Restart all systemd user services"
  task :restart_all do
    on roles(:app) do
      execute "/var/www/dummy_app/current/lib/capistrano/tasks/systemd_restart_script.sh"
    end
  end
end
