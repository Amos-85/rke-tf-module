resource "rke_cluster" "cluster" {

  cloud_provider {
    name = var.cloud-provider
  }

  cluster_name = "${var.k8s-cluster-name}-${random_uuid.cluster-id.result}"

   dynamic nodes {
     for_each = aws_instance.k8s-nodes
     content {
       address = nodes.value.public_dns
       internal_address = nodes.value.private_ip
       user = var.user
       role = [lookup(nodes.value.tags, "Role")]
       ssh_key = file(var.rke_ec2_ssh_key)
     }
  }

  services {
    etcd {
      # for etcd snapshots
      backup_config {
        interval_hours = var.s3-backup-config.interval_hours
        retention = var.s3-backup-config.retention
        #  # s3 specific parameters
        s3_backup_config {
          bucket_name = var.s3-backup-config.bucket_name
          folder  = "${var.s3-backup-config.folder}-${random_uuid.cluster-id.result}"
          region  = var.s3-backup-config.region
          endpoint = var.s3-backup-config.endpoint
      }
      }
    }
  }

  authorization {
    mode = "rbac"
  }

  authentication {
    strategy = "x509"
    sans = var.k8s-api-sans-hosts
  }

  ingress {
    provider = "none"
  }

  network {
    plugin = var.k8s-network-plugin
  }

//  addons_include = []
//
//  addons =<<EOL
//---
//EOL
}

resource "local_file" "kube_cluster_yaml" {
  filename = "./kube_config_cluster.yml"
  content  = rke_cluster.cluster.kube_config_yaml
  file_permission = "644"
}

resource "random_uuid" "cluster-id" {}