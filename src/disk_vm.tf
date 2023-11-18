resource "yandex_compute_disk" "disks" {
  count = 3

  name      = "disk-${count.index + 1}"
  type      = "network-hdd"
  image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
  size      = 5
}

resource "yandex_compute_instance" "storage" {
  name = "storage"
  resources {
    cores           = 2
    memory          = 1
    core_fraction   = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = "network-hdd"
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks.*.id
    content {
      disk_id = secondary_disk.value
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
    security_group_ids = [
      yandex_vpc_security_group.example.id
    ]
  }

  metadata = {
  ssh-keys = "ubuntu:${local.ssh-keys}"
  serial-port-enable = "1"
  }
}