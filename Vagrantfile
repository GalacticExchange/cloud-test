PRIVATE_IP = "10.1.0.201"
PRIVATE_MASK = "255.0.0.0"
GATEWAY = "10.1.0.1"




Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.ssh.username="vagrant"
  config.ssh.password="vagrant"

  config.vm.define "ui", primary: true do |main|

    # eth1
    # problem in Ubuntu 16: "eth0" => "enp3s0"
    config.vm.network "public_network", auto_config: false, bridge: 'ensp0'
    config.vm.provision "shell", run: "always", inline: "ifconfig eth1 " + PRIVATE_IP + " netmask " + PRIVATE_MASK + " up"
    main.vm.provision "shell", run: "always", inline: "route add default gw "+ GATEWAY
    # gateway

    # main.vm.provider "virtualbox" do |vb|
    #
    #   # vb.gui = true
    #
    #   #vb.memory = "4024"
    # end
  end

  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL


end