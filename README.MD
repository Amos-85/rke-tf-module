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

