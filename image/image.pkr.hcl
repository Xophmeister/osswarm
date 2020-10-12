variable "platform"       {}
variable "alpine_version" { default = "3.12.0" }
variable "alpine_flavour" { default = "virt" }
variable "architecture"   { default = "x86_64" }

locals {
  # Platform-dependent options for QEMU
  qemu = {
    "Linux" = {
      display     = "gdk"
      accelerator = "kvm"
    }
    "Darwin" = {
      display     = "cocoa"
      accelerator = "hvf"
    }
  }

  # Get the major and minor Alpine version components (e.g., 1.2.3 -> 1.2)
  major_version = "${regex_replace(var.alpine_version, "\\.\\d+$", "")}"
  alpine_iso = "http://dl-cdn.alpinelinux.org/alpine/v${local.major_version}/releases/${var.architecture}/alpine-${var.alpine_flavour}-${var.alpine_version}-${var.architecture}.iso"
}

source "qemu" "image" {
  qemu_binary         = "qemu-system-${var.architecture}"
  accelerator         = "${local.qemu[var.platform].accelerator}"
  display             = "${local.qemu[var.platform].display}"
  use_default_display = true
  headless            = true

  net_device          = "virtio-net"
  disk_interface      = "virtio"
  disk_size           = "1000M"

  iso_url             = "${local.alpine_iso}"
  iso_checksum        = "file:${local.alpine_iso}.sha256"

  vm_name             = "image.qcow2"
  format              = "qcow2"
  http_directory      = "src"
  output_directory    = "build"

  ssh_username        = "root"
  ssh_password        = "alpine"
  shutdown_command    = "poweroff"

  boot_wait           = "45s"
  boot_key_interval   = "10ms"
  boot_command = [
    # Login
    "root<enter><wait>",

    # Bring up NIC and download bootstrap script
    "ifconfig eth0 up && udhcpc -i eth0<enter><wait>",
    "wget http://{{ .HTTPIP }}:{{ .HTTPPort }}/bootstrap.sh<enter><wait>",

    # Install Alpine
    "chmod +x bootstrap.sh && ./bootstrap.sh<enter>"
  ]
}

build {
  sources = ["sources.qemu.image"]
  provisioner "ansible" {
    playbook_file = "src/playbook.yml"
    extra_arguments = [
      "--extra-vars", "major_version=${local.major_version}"
    ]
  }
}
