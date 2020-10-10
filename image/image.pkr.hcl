variable "alpine_version" { default = "3.12.0" }
variable "alpine_flavour" { default = "virt"   }
variable "architecture"   { default = "x86_64" }

locals {
  # Get the major and minor version components (e.g., 1.2.3 -> 1.2)
  _major_version = "${join(".", slice(split(".", var.alpine_version), 0, 2))}"
  alpine_iso = "http://dl-cdn.alpinelinux.org/alpine/v${local._major_version}/releases/${var.architecture}/alpine-${var.alpine_flavour}-${var.alpine_version}-${var.architecture}.iso"
}

source "qemu" "image" {
  qemu_binary      = "qemu-system-${var.architecture}"
  display          = "cocoa"
  use_default_display = true
  #headless        = true
  http_directory   = "src"

  vm_name          = "image.qcow2"
  format           = "qcow2"
  output_directory = "build"

  iso_url          = "${local.alpine_iso}"
  iso_checksum     = "file:${local.alpine_iso}.sha256"

  ssh_username     = "root"
  ssh_password     = "alpine"
  shutdown_command = "poweroff"

  net_device     = "virtio-net"
  disk_interface = "virtio"
  disk_size      = "1000M"

  boot_wait = "45s"
  boot_key_interval = "10ms"
  boot_command = [
    # Login
    "root<enter><wait>",

    # Bring up NIC and download bootstrap script
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait5>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh<enter><wait>",

    # Bootstrap
    "chmod +x bootstrap.sh && ./bootstrap.sh<enter>"
  ]
}

build {
  sources = ["sources.qemu.image"]
}
