terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = var.yc_token 
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

# commented out to not max out on vpc network quota

#resource "yandex_vpc_network" "this" {
#  name = "default" 
#}

resource "yandex_vpc_subnet" "this" {
  name           = "sf-proekt-9"
  zone           = "ru-central1-a"
  network_id     = "enp1rcsgq9dhq3btkgj1" #yandex_vpc_network.this.id to use newly created network
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_compute_instance" "vm1" {
  
  name = "vm1"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id_ubuntu
      size        = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.this.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }
  
}

resource "yandex_compute_instance" "vm2" {

  name = "vm2"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id_ubuntu
      size        = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.this.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

}

resource "yandex_compute_instance" "vm3" {

  name = "vm3"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id_centos
      size        = 20
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.this.id
    nat       = true
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

}


output "internal_ip_address_vm1" {
  value = yandex_compute_instance.vm1.network_interface.0.ip_address
}

output "external_ip_address_vm1" {
  value = yandex_compute_instance.vm1.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm2" {
  value = yandex_compute_instance.vm2.network_interface.0.ip_address
}

output "external_ip_address_vm2" {
  value = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
}

output "internal_ip_address_vm3" {
  value = yandex_compute_instance.vm3.network_interface.0.ip_address
}

output "external_ip_address_vm3" {
  value = yandex_compute_instance.vm3.network_interface.0.nat_ip_address
}


# generate inventory file for Ansible
# add instances here
# modify hosts.tpl with variables from here
resource "local_file" "inventory" {
  content = templatefile("${path.module}/hosts.tpl",
    {
      vm1 = yandex_compute_instance.vm1.network_interface.*.nat_ip_address
      vm2 = yandex_compute_instance.vm2.network_interface.*.nat_ip_address
      vm3 = yandex_compute_instance.vm3.network_interface.*.nat_ip_address
    }


  )
  filename = "../ansible/inventory.ini"
}      
