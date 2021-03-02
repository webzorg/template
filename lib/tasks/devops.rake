# frozen_string_literal: true

namespace :devops do
  desc "Setup deployment VPS"
  task setup: :environment do
    client = Devops::Client.new
    result_hash = client.create_droplet

    abort "Something went wrong" unless result_hash[:droplet].is_a? DropletKit::Droplet

    File.delete(".env_production") if File.exist?(".env_production")
    ssh_config = lambda { |app_name, droplet_ip|
      <<~SSH_CONFIG

        Host #{app_name}
          HostName #{droplet_ip}
          User devops
          ServerAliveInterval 60
      SSH_CONFIG
    }

    app_name = client.droplet_params[:name]
    droplet_ip = client.droplet_ip

    `sed -i "/Host #{app_name}/!b;n;c\\\tHostName #{droplet_ip}" ~/.ssh/config`

    ssh_config_file = File.new("#{Dir.home}/.ssh/config")
    if result_hash[:already_exists].blank? && !ssh_config_file.read.include?("Host #{app_name}")
      File.open("#{Dir.home}/.ssh/config", "a") do |f|
        f.puts ssh_config.call(app_name, droplet_ip)
      end
    end
  end
end
