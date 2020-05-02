namespace :devops do
  desc "Setup deployment VPS"
  task setup: :environment do
    client = Lasha::Devops::Client.new
    client.delete_droplet
    result_hash = client.create_droplet

    abort "Something went wrong" unless result_hash[:droplet].is_a? DropletKit::Droplet

    ssh_config = lambda { |app_name, droplet_ip|
      <<~SSH_CONFIG

        Host #{app_name}
          HostName #{droplet_ip}
          User devops
      SSH_CONFIG
    }

    app_name    = client.droplet_params[:name]
    droplet_ip = client.droplet_ip

    `sed -i "/Host #{app_name}/!b;n;c\\\tHostName #{droplet_ip}" ~/.ssh/config`

    if result_hash[:already_exists].blank?
      File.open("#{Dir.home}/.ssh/config", "a") do |f|
        f.puts ssh_config.call(app_name, droplet_ip)
      end
    end
  end
end
