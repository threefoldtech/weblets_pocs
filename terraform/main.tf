terraform {
  required_providers {
    grid = {
      source = "threefoldtech/grid"
    }
  }
}

provider "grid" {
}

resource "grid_scheduler" "sched" {
  # a machine for the first server instance
  requests {
    name = "dev_machine"
    cru  = 4
    sru  = 20480
    mru  = 8192
  }
}

resource "grid_network" "net1" {
  nodes = distinct([
    grid_scheduler.sched.nodes["dev_machine"],
  ])
  ip_range    = "10.1.0.0/16"
  name        = "dev_network"
  description = "dev machine network"
}

resource "grid_deployment" "dev_machine" {
  node         = grid_scheduler.sched.nodes["dev_machine"]
  network_name = grid_network.net1.name
  ip_range     = lookup(grid_network.net1.nodes_ip_range, grid_scheduler.sched.nodes["dev_machine"], "")
  vms {
    name        = "dev_vm"
    flist       = "https://hub.grid.tf/essam.3bot/mohammedessam-ubuntu_devenv-20.04.flist"
    cpu         = 4
    memory      = 8192
    rootfs_size = 20480
    entrypoint  = "/init.sh"
    env_vars = {
      SSH_KEY             = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDmm8OzLt+lTdGaMUwMFcw0P+vr+a/h/UsR//EzzeQsgNtC0bdls4MawVEhb3hNcycEQNd2P/+tXdLC4qcaJ6iABYip4xqqAeY098owGDYhUKYwmnMyo+NwSgpjZs8taOhMxh5XHRI+Ifr4l/GmzbqExS0KVD21PI+4sdiLspbcnVBlg9Eg9enM///zx6rSkulrca/+MnSYHboC5+y4XLYboArD/gpWy3zwIUyxX/1MjJwPeSnd5LFBIWvPGrm3cl+dAtADwTZRkt5Yuet8y5HI73Q5/NSlCdYXMtlsKBLpJu3Ar8nz1QfSQL7dB8pa7/sf/s8wO17rXqWQgZG6JzvZ root@ahmed-Inspiron-3576"
      CODESERVER_PASSWORD = "hamada"
      TWIN_ID             = 56
    }
    planetary = true
  }
}

output "planetary_ip" {
  value = grid_deployment.dev_machine.vms[0].ygg_ip
}
