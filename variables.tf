variable "instance_count" {
  description = "nodes count map"
  type = map(number)
    default = {
    control-plane = 1
    etcd          = 1
    worker        = 2
  }
}

variable "instance_type" {
  description = "instance type"
  type = map(string)
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
  default = "ami-002ab867b8b8591d5"
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
  type = map(string)
  default = {
    interval_hours = 12
    retention = 6
    bucket_name = "rancher-rke-k8s-backup"
    folder = "rancher"
    region = "us-east-2"
    endpoint = "s3.amazonaws.com"
  }
}
