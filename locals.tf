locals {
  common-tags = {
    Terraform   = "true"
    Environment = "dev-research"
    Owner       = "Amos"
  }

  instances = {
    control-plane = flatten(
    [
    for index in range(var.instance_count.control-plane) : {
      instance_index = index
      instance_name = "control-plane"
      instance_type = var.instance_type.control-plane
      tags = {
        Role = "controlplane"
        Name = "${var.name}-control-plane-${index}"
        "kubernetes.io/cluster/${random_uuid.cluster-id.result}" = "owned"
      }
          }
      ]
    )
    etcd = flatten(
    [
    for index in range(var.instance_count.etcd) : {
      instance_index = index
      instance_name = "etcd"
      instance_type = var.instance_type.etcd
      tags = {
        Role = "etcd"
        Name = "${var.name}-etcd-${index}"
        "kubernetes.io/cluster/${random_uuid.cluster-id.result}" = "owned"
      }
    }
    ]
    )
    worker = flatten(
    [
    for index in range(var.instance_count.worker) : {
      instance_index = index
      instance_name = "worker"
      instance_type = var.instance_type.worker
      tags = {
        Role = "worker"
        Name = "${var.name}-worker-${index}"
        "kubernetes.io/cluster/${random_uuid.cluster-id.result}" = "owned"
      }
    }
    ]
    )
  }
}