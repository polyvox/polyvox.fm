# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
    sudo dpkg -i erlang-solutions_1.0_all.deb
    rm erlang-solutions_1.0_all.deb
    curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
    sudo apt-get update
    sudo apt-get dist-upgrade -y
    sudo apt-get install -y nginx erlang erlang-dev elixir build-essential nodejs git postgresql inotify-tools mg unzip
    mix local.hex --force
    mix archive.install https://github.com/phoenixframework/phoenix/releases/download/v1.0.4/phoenix_new-1.0.4.ez --force --sha512
    mkdir -p ~/polyvox/priv/static
    sudo sed -i 's/root \\/usr\\/share\\/nginx\\/html;/root \\/home\\/vagrant\\/polyvox\\/priv\\/static\\/;/' /etc/nginx/sites-available/default
    sudo sed -i 's/try_files $uri $uri\\/ =404;/proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for; proxy_set_header Host $http_host; proxy_pass_header X-Accel-Redirect; proxy_read_timeout 300s; if (!-f $request_filename) { proxy_pass http:\\/\\/127.0.0.1:4001; break; }/' /etc/nginx/sites-available/default
    sudo nginx -s reload
    sudo npm install -g brunch
    mix local.rebar
    echo "export MIX_ENV=prod" >> ~/.bash_profile
    echo "export PORT=4001" >> ~/.bash_profile
    sudo -u postgres createuser -d polyvox_beta_prod
    sudo -u postgres psql -c "create database polyvox_beta_prod;"
    sudo -u postgres psql -c "alter database polyvox_beta_prod owner to polyvox_beta_prod;"
    sudo -u postgres psql postgres -c "alter user polyvox_beta_prod with encrypted password 'md5b22abc21810b75ae5605966301c17755';"
  SHELL
end

