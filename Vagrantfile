# -*- mode: ruby -*-
# vi: set ft=ruby :
#

# Set the appropriate number of nodes here
MASTERS = ENV["MASTERS"].to_i
INFRA = ENV["INFRA"].to_i
APPS = ENV["APPS"].to_i

# Set the number of block devices per node
DISKS = 8

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.ssh.private_key_path = ["./keys/ocplab_rsa", "~/.vagrant.d/insecure_private_key"]

    config.vm.provider :libvirt do |v,override|
        override.vm.box = "centos/7"
        override.vm.synced_folder '.', '/home/vagrant/sync', disabled: true
    end
    config.vm.provider :virtualbox do |v|
        config.vm.box = "centos/7"
    end

    # Configure the bastion host
    config.vm.define "ocp-cluster" do |bastion|
        bastion.vm.network :private_network, ip: "192.168.10.90"
        bastion.vm.host_name = "ocp-cluster"
        bastion.vm.provider :virtualbox do |vb|
            vb.memory = 2048
            vb.cpus = 2
        end

        bastion.vm.provider :libvirt do |lv|
            lv.memory = 2048
            lv.cpus = 2
        end

        bastion.vm.provision "file", source: "keys/ocplab_rsa.pub", destination: "~/.ssh/authorized_keys"
        # Fix for master-api service startup issue on vagrant, generically applied everywhere
        bastion.vm.provision "shell", inline: "sudo sed -i \"/^127.0.0.1.*$HOSTNAME/d\" /etc/hosts"

    end

    # Configure master nodes
    (1..MASTERS).each do |i|
        config.vm.define "ocp-master-0#{i}" do |master|
            master.vm.hostname = "ocp-master-0#{i}"
            master.vm.network :private_network, ip: "192.168.10.10#{i}"
            (0..DISKS-7).each do |d|
                master.vm.provider :virtualbox do |vb|
                    vb.customize [ "createhd", "--filename", "ocp-master-0#{i}-#{d}.vdi", "--size", 500*1024 ]
                    vb.customize [ "storageattach", :id, "--storagectl", "SATA Controller", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "ocp-master-0#{i}-#{d}.vdi" ]
                    vb.memory = 4096
                    vb.cpus = 2
                end
                master_driverletters = ('b'..'z').to_a
                master.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{master_driverletters[d]}", :path => "ocp-master-0#{i}-#{d}.disk", :size => '500G'
                    lv.memory = 4096
                    lv.cpus =2
                end
            end
            master.vm.provision "file", source: "keys/ocplab_rsa.pub", destination: "~/.ssh/authorized_keys"
            # Fix for master-api service startup issue on vagrant, generically applied everywhere
            master.vm.provision "shell", inline: "sudo sed -i \"/^127.0.0.1.*$HOSTNAME/d\" /etc/hosts"
        end
    end

    # Configure infra nodes
    (1..INFRA).each do |i|
        config.vm.define "ocp-infra-0#{i}" do |infra|
            infra.vm.hostname = "ocp-infra-0#{i}"
            infra.vm.network :private_network, ip: "192.168.10.11#{i}"
            (0..DISKS-1).each do |d|
                infra.vm.provider :virtualbox do |vb|
                    vb.customize [ "createhd", "--filename", "ocp-infra-0#{i}-#{d}.vdi", "--size", 500*1024 ]
                    vb.customize [ "storageattach", :id, "--storagectl", "SATA Controller", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "disk-#{i}-#{d}.vdi" ]
                    vb.memory = 4096
                    vb.cpus = 2
                end
                infra_driverletters = ('b'..'z').to_a
                infra.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{infra_driverletters[d]}", :path => "ocp-infra-0#{i}-#{d}.disk", :size => '500G'
                    lv.memory = 4096
                    lv.cpus =2
                end
            end
            infra.vm.provision "file", source: "keys/ocplab_rsa.pub", destination: "~/.ssh/authorized_keys"
            # Fix for master-api service startup issue on vagrant, generically applied everywhere
            infra.vm.provision "shell", inline: "sudo sed -i \"/^127.0.0.1.*$HOSTNAME/d\" /etc/hosts"
        end
    end


    # Configure apps nodes
    (1..APPS).each do |i|
        config.vm.define "ocp-apps-0#{i}" do |apps|
            apps.vm.hostname = "ocp-apps-0#{i}"
            apps.vm.network :private_network, ip: "192.168.10.12#{i}"
            # Allocate only (DISKS-4) disks on masters.
            (0..DISKS-4).each do |d|
                apps.vm.provider :virtualbox do |vb|
                    vb.customize [ "createhd", "--filename", "ocp-apps-0#{i}-#{d}.vdi", "--size", 500*1024 ]
                    vb.customize [ "storageattach", :id, "--storagectl", "SATA Controller", "--port", 3+d, "--device", 0, "--type", "hdd", "--medium", "disk-#{i}-#{d}.vdi" ]
                    vb.memory = 4096
                    vb.cpus = 2
                end
                apps_driverletters = ('b'..'z').to_a
                apps.vm.provider :libvirt do  |lv|
                    lv.storage :file, :device => "vd#{apps_driverletters[d]}", :path => "ocp-apps-0#{i}-#{d}.disk", :size => '500G'
                    lv.memory = 4096
                    lv.cpus =2
                end
            end
            apps.vm.provision "file", source: "keys/ocplab_rsa.pub", destination: "~/.ssh/authorized_keys"
            # Fix for master-api service startup issue on vagrant, generically applied everywhere
            apps.vm.provision "shell", inline: "sudo sed -i \"/^127.0.0.1.*$HOSTNAME/d\" /etc/hosts"
        end
    end

end

