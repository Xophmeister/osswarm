# osswarm

## Dependencies

* GNU make
* Openstack CLI
* `clouds.yaml`
* Packer (tested with 1.6.4)
* QEMU (tested with 5.1.0)
* Ansible (tested with 2.9.13)
* Ansible `community.general' modules

## To Do

- [ ] Image
  - [ ] Netdata configuration
    - [ ] Docker monitoring
    - [ ] Cluster monitoring
  - [ ] `cloud-init` configuration
- [ ] Infrastructure
  - [ ] SSH key
  - [ ] Networking
    - [ ] Network
    - [ ] Security groups
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
