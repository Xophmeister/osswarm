# osswarm

Build and deploy a Docker Swarm cluster to OpenStack.

## Usage

The [Infoblox][infoblox] configuration will first need to be defined in
`infrastructure/dns/infoblox.yaml`. See [the example
configuration](infrastructure/dns/infoblox.yaml.example) for details.

Then, to build and deploy a Docker Swarm to the given OpenStack project,
per the `clouds.yaml` configuration, setting DNS records under the given
`${DOMAIN}`, run:

    make CLOUD=${OS_CLOUD} DOMAIN=${DOMAIN}

Other Make variables can be set to fine-tune the cluster; please see the
appropriate [documentation](#build-process) below. The following
additional Make targets are available:

* **`cloud-clean`** \
  Destroy a deployed Docker Swarm and all its related infrastructure
* **`clean`** \
  Clean the local build state, desynchronising it from any cloud state
  (i.e., run `cloud-clean` first)
* **`help`** \
  This documentation

The build is optimised for the OpenStack environment provided at the
[Wellcome Sanger Institute][sanger]. It can be modified for different
OpenStack environments by focusing on the following
[configuration](#sanger-specific-configuration).

Note that while Make is used to build and deploy the cluster, there will
be a disconnect between cloud and local build artefacts. No attempt is
made to synchronise these. For example, once an image is deployed,
changes to its sources will not trigger a full rebuild until `make
cloud-clean` is manually invoked.

<!-- ## Monitoring -->

## Dependencies

* [GNU Make][make]
* [OpenSSH][openssh]
* [Openstack CLI][openstack-cli] (tested with 5.4.0) and a `clouds.yaml`
* [Packer][packer] (tested with 1.6.4)
* [QEMU][qemu] (tested with 5.1.0)
* [Ansible][ansible] (tested with 2.9.13)
  * Ansible [`community.general` modules][ansible-modules] (tested with
    1.2.0)
* [Terraform][terraform] (tested with 0.13.4)
  * Terraform [OpenStack provider][terraform-openstack] (tested with
    1.32.0)
  * Terraform [local provider][terraform-local] (tested with 2.0.0)
  * Terraform [Infoblox provider][terraform-infoblox] (tested with
    1.1.0)

## Build Process

### Image

Build and deploy an [Alpine Linux][alpine] image to the OpenStack
project. The image is built inside QEMU and is provisioned with:

* [`cloud-init`][cloud-init]
* [Netdata][netdata]
* [Docker][docker]

The following Make variables are available to `image/Makefile`:

* **`ARCH`** \
  The CPU architecture used by the image and the OpenStack environment
  (defaults to `x86_64`)
* **`ALPINE_VERSION`** \
  The version of Alpine Linux used by the image (defaults to `3.12.0`)
* **`ALPINE_FLAVOUR`** \
  The "flavour" of Alpine Linux used by the image (defaults to `virt`)

The image will be built locally as `image/build/image.qcow2`. It will
then be deployed to the OpenStack project as `osswarm-${ARCH}` (e.g.,
`osswarm-x86_64`).

### Infrastructure

The following Make variables are available to `infrastructure/Makefile`:

* **`NAME`** \
  The name used for the cluster infrastructure (defaults to the current
  username)
* **`SECRET_KEY`** \
  The path to an SSH secret key (defaults to any match of `~/.ssh/id_*`;
  falling back to `~/.ssh/osswarm-${NAME}_rsa`, which will be generated
  if it doesn't exist)
* **`FLAVOUR`** \
  The machine flavour for all nodes in the cluster (defaults to
  `m2.medium`)
* **`WORKERS`** \
  The number of worker nodes in the cluster (defaults to 1)
* **`MANAGEMENT_SUBDOMAIN`** \
  The subdomain from which to manage the cluster (defaults to
  `management`)
* **`SERVICE_SUBDOMAIN`** \
  The subdomain from which to access cluster services (defaults to
  `services`)

<!-- ### Orchestration -->

## Sanger-Specific Configuration

The following *may* need to be changed for a general OpenStack cloud:

* **`image/src/docker.json`** \
  Configures Docker's networking to avoid internal conflicts
* **DNS** \
  DNS is provided by Infoblox and is defined in the following locations:
  * **`infrastructure/Makefile`** \
    Checks for the Infoblox configuration
  * **`infrastructure/dns`** \
    Terraform module utilising the Infoblox provider

## To Do

- [ ] Image
  - [ ] Provisioning
    - [ ] Cinder/S3 Docker volume drivers
  - [ ] Netdata configuration
    - [ ] Docker monitoring
    - [ ] Cluster monitoring
- [ ] Infrastructure
  - [ ] Load Balancer (?)
- [ ] Orchestration
  - [ ] Prometheus (Docker/Netdata monitoring)
  - [ ] Swarm manager
  - [ ] Swarm workers
  - [ ] Traefik
- [ ] Documentation

<!-- References -->
[alpine]:              https://alpinelinux.org/
[ansible-modules]:     https://galaxy.ansible.com/community/general
[ansible]:             https://www.ansible.com/
[cloud-init]:          https://cloud-init.io/
[docker]:              https://www.docker.com/
[infoblox]:            https://www.infoblox.com/
[make]:                https://www.gnu.org/software/make
[netdata]:             https://www.netdata.cloud/
[openssh]:             https://www.openssh.com/
[openstack-cli]:       https://docs.openstack.org/python-openstackclient
[packer]:              https://www.packer.io/
[qemu]:                https://www.qemu.org/
[sanger]:              https://www.sanger.ac.uk/
[terraform-infoblox]:  https://www.terraform.io/docs/providers/infoblox
[terraform-local]:     https://www.terraform.io/docs/providers/local
[terraform-openstack]: https://registry.terraform.io/providers/terraform-provider-openstack/openstack
[terraform]:           https://www.terraform.io/
