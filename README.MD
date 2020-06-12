# Terraform Rancher Cluster Module #  

* The motivation is to create k8s cluster based on rke __rke terraform provider__ and tuning & configuring instances for each k8s role independently.     

* This terraform module provision rke k8s cluster based on __rancher-os ami__ that already include docker engine.    
 
 * tfvars  file example:
 ```
key_name = "user"
subnet_id = "subnet-56ea771a"
vpc_security_group_ids = ["sg-0ff023a98f281ef65"]
rke_ec2_ssh_key = "~/.ssh/user.pem"
k8s-api-sans-hosts = ["k8s.example.com"]
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami | ID of AMI to use for the instance | string | ami-002ab867b8b8591d5 | yes |
|instance_count | map object of k8s instances by roles | object | etcd=1,control-plane=1,worker=1 | yes |
|instance_type | object map of k8s instance types | object | etcd=t2.large,control-plane=t2.large,worker=t2.large | yes|
| root_block_device | root block device configuration | list(map(string)) | no | no |
|ebs_block_device | ebs block device | list(map(string)) | no | no |
|ephemeral_block_device| ephemeral block device |  list(map(string)) | no | no |
| Name | instances prefix name | string | rancher | yes |
| user | ssh user of ec2 instances | string | rancher | yes|
|monitor | monitor ec2 instances | bool | true | no|
|key_name| key pair name | string | no | yes |
|subnet_id | ec2 subnet id| string | no | yes |
|vpc_security_group_ids | list of vpc sg | list(string) | no | yes|
|rke_ec2_ssh_key| rke ssh key to deploy rke | string | no | yes |
|placement_group | placement group name | string | no | yes |
|k8s-cluster-name| k8s rke cluster name prefix | string | rancher | no |
|k8s-api-sans-hosts | rancher k8s api hosts list to authenticate k8s api | list(string)| no | yes |
|k8s-network-plugin| k8s network plugin | string | canal | yes |
|cloud-provider| rke cloud provider | string | aws | yes|
|s3-backup-config| rke s3 backup config | map(string) | interval_hours = 12, retention = 6, bucket_name = null ,folder = "rancher", region = "us-east-2", endpoint = "s3.amazonaws.com" | yes|
 

