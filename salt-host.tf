resource "yandex_compute_instance" "salt-main" {

  name     = "salt-main"
  hostname = "salt-main"

  resources {
    cores  = 2
    memory = 2
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet01.id
    nat       = true
  }

  metadata = {
    ssh-keys = "almalinux:${tls_private_key.ssh.public_key_openssh}"
  }

  connection {
    type        = "ssh"
    user        = "almalinux"
    private_key = tls_private_key.ssh.private_key_pem
    host        = self.network_interface.0.nat_ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'host is up'",
      "sudo echo 'LC_ALL=en_US.UTF-8' >> /etc/locale.conf",
      "sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm",
      "sudo dnf install wget mc vim -y",
      "sudo dnf update -y",
      "sudo dnf install -y ansible",
      "sudo mkdir -p /srv/salt/states",
      "mkdir -p /home/almalinux/salt"
    ]
  }

  provisioner "file" {
    source      = "ansible"
    destination = "/home/almalinux"
  }

  provisioner "file" {
    source      = "id_rsa"
    destination = "/home/almalinux/.ssh/id_rsa"
  }

  provisioner "file" {
    source      = "id_rsa.pub"
    destination = "/home/almalinux/.ssh/id_rsa.pub"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/almalinux/.ssh/id_rsa"
    ]
  }

  provisioner "file" {
    source      = "./ansible/ansible.cfg"
    destination = "/home/almalinux/ansible.cfg"
  }

  provisioner "file" {
    source      = "./salt/states"
    destination = "/home/almalinux/salt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo rpm --import https://repo.saltproject.io/salt/py3/redhat/8/x86_64/SALT-PROJECT-GPG-PUBKEY-2023.pub",
      "curl -fsSL https://repo.saltproject.io/salt/py3/redhat/8/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo",
      "sudo dnf install -y salt-master salt-syndic salt-api",
      # "ansible-playbook -u almalinux -v --diff -i /home/almalinux/ansible/hosts /home/almalinux/ansible/playbooks/main.yml",
    ]
  }

  provisioner "file" {
    source      = "./salt/master.conf"
    destination = "/home/almalinux/salt/master.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /home/almalinux/salt/master.conf /etc/salt/master.d/",
      "sudo cp -r /home/almalinux/salt/states/* /srv/salt/states/",
      "sudo systemctl enable salt-master --now",
      "ansible-playbook -u almalinux -i /home/almalinux/ansible/hosts /home/almalinux/ansible/playbooks/main.yml",
      "sleep 60 && sudo salt-key -Ay",
      "sleep 60",
      # "sudo salt '*' selinux.setenforce disabled",
      "sudo salt '*' state.apply"
    ]
  }

  depends_on = [
    yandex_compute_instance.nginx,
    yandex_compute_instance.db,
    yandex_compute_instance.backend,
  ]
}
