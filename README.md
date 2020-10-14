# osswarm

Build and deploy a Docker Swarm cluster to OpenStack.

## Usage

    make CLOUD=${OS_CLOUD}

Build and deploy a Docker Swarm to the given OpenStack project, per the
`clouds.yaml` configuration.

By default, the cluster will be named per your username; this can be
overridden with the `NAME` Make variable. Other Make variables can be
set to fine-tune the cluster; please see the appropriate
[documentation](#build-process) below.

Other Make targets are available:

* **`clean`** \
  Clean the local build state
* **`cloud-clean CLOUD=${OS_CLOUD}`** \
  Destroy a deployed Docker Swarm
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
* [Openstack CLI][openstack-cli] (tested with 5.4.0) and a `clouds.yaml`
* [Packer][packer] (tested with 1.6.4)
* [QEMU][qemu] (tested with 5.1.0)
* [Ansible][ansible] (tested with 2.9.13)
* Ansible [`community.general` modules][ansible-modules] (tested with
  1.2.0)
* [Terraform][terraform] (tested with 0.13.4)
* Terraform [OpenStack provider][terraform-openstack] (tested with
  1.32.0)

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
  (default `x86_64`)
* **`ALPINE_VERSION`** \
  The version of Alpine Linux used by the image (default `3.12.0`)
* **`ALPINE_FLAVOUR`** \
  The "flavour" of Alpine Linux used by the image (default `virt`)

The image will be built locally as `image/build/image.qcow2`. It will
then be deployed to the OpenStack project as `osswarm-${ARCH}` (e.g.,
`osswarm-x86_64`).

### Infrastructure

<!-- Write me... -->

<!-- ### Orchestration -->

## Sanger-Specific Configuration

The following *may* need to be changed for a general OpenStack cloud:

* **`image/src/docker.json`** \
  Configures Docker's networking to avoid internal conflicts

## To Do

- [ ] Image
  - [ ] Netdata configuration
    - [ ] Docker monitoring
    - [ ] Cluster monitoring
- [ ] Infrastructure
  - [ ] SSH key
  - [ ] Networking
    - [ ] Network
    - [ ] Floating IP
  - [ ] Compute
  - [ ] Load Balancer
  - [ ] DNS
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
[make]:                https://www.gnu.org/software/make
[netdata]:             https://www.netdata.cloud/
[openstack-cli]:       https://docs.openstack.org/python-openstackclient
[packer]:              https://www.packer.io/
[qemu]:                https://www.qemu.org/
[sanger]:              https://www.sanger.ac.uk/
[terraform]:           https://www.terraform.io/
[terraform-openstack]: https://registry.terraform.io/providers/terraform-provider-openstack/openstack
