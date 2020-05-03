class Lasha::Devops::Client
  attr_reader :client, :ssh_key_id, :cloud_config
  attr_accessor :droplet_params, :droplet

  def initialize
    @client = DropletKit::Client.new(access_token: ENV["PERSONAL_DO"])
    debgen_ssh_key = client.ssh_keys.all.select { |k| k.name.eql?("debgen") }.first
    @ssh_key_id = debgen_ssh_key.id unless debgen_ssh_key.nil?
    @cloud_config = YAML.load(
      File.read(File.expand_path("cloud_config.yml", __dir__)) % {
        app_name: Rails.application.config.app_name,
        ruby_version: RUBY_VERSION
      }
    )
    # @volume_name = "geth-node-volume2"

    @droplet_params = {
      name: Rails.application.config.app_name,
      region: "fra1",
      size: "s-1vcpu-1gb", # (s-1vcpu-1gb $5) (s-2vcpu-2gb $15) (s-3vcpu-1gb $15) (s-1vcpu-3gb $15)
      image: "debian-10-x64", # images
      ssh_keys: [ssh_key_id],
      backups: true,
      ipv6: false,
      private_networking: false,
      user_data: "#cloud-config\n#{cloud_config.to_yaml}",
      monitoring: true,
      # volumes: (volume ? [create_volume(volume_params)] : nil),
      tags: [Rails.application.config.app_name]
    }

    fetch_droplet && droplet_already_exists if droplet

    client
  end

  def create_droplet
    fetch_droplet
    result_hash = ->(already_exists) { { already_exists: already_exists, droplet: droplet } }

    if droplet
      droplet_already_exists
      result_hash.call(true)
    elsif @client.droplets.create(DropletKit::Droplet.new(droplet_params))
      puts "Waiting 30 seconds to get IP"
      progress_bar(duration: 30)

      puts "\n Successfully created #{droplet_params[:name]}"
      fetch_droplet
      puts "Droplet IP: #{droplet_ip}"

      puts "Waiting 30 seconds for droplet to setup"
      progress_bar(duration: 30)

      result_hash.call(false)
    end
  end

  def fetch_droplet(params=droplet_params)
    self.droplet = client.droplets.all.select { |d| d.name.eql?(params[:name]) }.first
  end

  # def delete_droplet(params=droplet_params)
  #   droplet = fetch_droplet(params)

  #   return if droplet.blank?

  #   @client.droplets.delete(id: droplet.id)
  #   sleep 10
  # end

  def regions
    regions = client.regions.all
    regions.map.with_index { |obj, index| [index, obj.slug, obj.name] }
  end

  def images
    images = @client.images.all
    images.map.with_index { |obj, index| [index, obj.slug, obj.name] }
  end

  def sizes
    sizes = @client.sizes.all.select(&:available).map(&:to_h)
    sizes.each_with_index do |a, index|
      puts "#{index} ******************"
      pp a.except(:regions, :price_hourly, :available)
    end
  end

  def droplet_already_exists
    puts "Droplet with name: #{droplet_params[:name]}, already exists."
    puts "Droplet IP: #{droplet_ip}"
  end

  def progress_bar(duration: 30)
    progressbar = ProgressBar.create
    duration.times { progressbar.progress += 100 / duration; sleep 1 }
  end

  def droplet_ip
    droplet ? droplet.networks.v4.first.ip_address : nil
  end

  # Droplet
  # create_droplet(droplet_params(false))
  # pp fetch_droplet(name: "cardano")
  # pp delete_droplet(name: "cardano")

  # Volume
  # pp create_volume(volume_params)
  # pp find_volume(name: "cardano-volume")
  # pp delete_volume(name: "cardano-volume")

  # def volume_params
  #   {
  #     size_gigabytes: 250,
  #     name: @volume_name,
  #     description: "",
  #     region: "fra1"
  #   }
  # end

  # def create_volume(params)
  #   @client.volumes.create(DropletKit::Volume.new(params)).id
  # end

  # def find_volume(params)
  #   @client.volumes.all.select { |d| d.name.eql?(params[:name]) }.first
  # end

  # def delete_volume(params)
  #   @client.volumes.delete(id: find_volume(params).id)
  # end
end
