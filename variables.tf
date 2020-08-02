variable "instance_count" {
  description = "nodes count map object"
  type = object({
    control-plane = number
    etcd          = number
    worker        = number
  })
    default = {
    control-plane = 1
    etcd          = 1
    worker        = 2
  }
}

variable "instance_type" {
  description = "instance type"
  type = object({
    control-plane = string
    etcd = string
    worker = string
  })
  default = {
    control-plane = "t2.large"
    etcd          = "t2.large"
    worker        = "t2.large"
  }
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(map(string))
  default     = [{
    volume_type = "gp2"
    volume_size = 100
    iops = 300
  }]
}

variable "ebs_block_device" {
  description = "ebs block devices"
  type = list(map(string))
  default = []
}

variable "ephemeral_block_device" {
  description = "ephemeral block device"
  type = list(map(string))
  default = []
}

variable "name" {
  description = "Name of instances"
  type = string
  default = "Rancher"
}

variable "ami" {
  description = "ami for ec2 instances"
  type = string
  default = "ami-08faee1387289d316"
  validation {
    condition     = can(regex("^ami-", var.ami))
    error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "user" {
  description = "ssh user of ec2 instances"
  type = string
  default = "rancher"
}

variable "monitoring" {
  description = "monitor ec2 instances"
  type = bool
  default = true
}

variable "key_name" {
  description = "key pair name"
  type = string
  default = ""
}

variable "subnet_id" {
  description = "ec2 subnet"
  type = string
  default = ""
}

variable "vpc_security_group_ids" {
  description = "security groups"
  type = list(string)
  default = []
}

variable "rke_ec2_ssh_key" {
  description = "ssh key for to deploy rke"
  type = string
  default = ""
}

variable "placement_group" {
  description = "instance placement group"
  type = string
  default = ""
}

variable "k8s-cluster-name" {
  description = "K8S cluster ID"
  type = string
  default = "rancher"
}

variable "k8s-api-sans-hosts" {
  description = "rancher k8s api hosts list to authenticate k8s api"
  type = list(string)
  default = null
}

variable "k8s-network-plugin" {
  description = "k8s network plugin"
  type = string
  default = "canal"
}

variable "cloud-provider" {
  description = "rke cloud provider"
  type = string
  default = "aws"
}

variable "s3-backup-config" {
  description = "s3 backup configuration for cluster"
  type = map(any)
  default = null
}

variable "kube_api_feature_gates" {
  description = "kube api feature gates"
  type = string
  default = null
}

variable "kubelet_feature_gates" {
  description = "kubelet feature gates"
  type = string
  default = null
}

variable "restore_rke" {
  description = "restore rke from snapshot"
  type = map(any)
  default = {
    restore = false
    snapshot_name = null
  }
}

variable "prefix_path" {
  description = " rke prefix path"
  type = string
  default = null
}