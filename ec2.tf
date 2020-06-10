resource "aws_instance" "k8s-nodes" {
  for_each        = {
  for inst in concat(
  local.instances.control-plane,
  local.instances.etcd,
  local.instances.worker
  ) : format("%s-%02d", inst.instance_name, inst.instance_index + 1) => inst
  }
  ami                     = var.ami
  instance_type           = each.value.instance_type
  key_name                = var.key_name
  monitoring              = var.monitoring
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.vpc_security_group_ids
  iam_instance_profile    = aws_iam_instance_profile.ec2_k8s_profile.name
  tags                    = merge(local.common-tags,each.value.tags)
  placement_group         = var.placement_group
  provisioner "remote-exec" {
    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type = "ssh"
      user = var.user
      private_key = file(var.rke_ec2_ssh_key)
    }
    inline = [
      "wait-for-docker",
    ]
  }


  dynamic "ebs_block_device" {
    for_each = var.ebs_block_device
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = ebs_block_device.value.device_name
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      iops                  = lookup(ebs_block_device.value, "iops", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
      snapshot_id           = lookup(ebs_block_device.value, "snapshot_id", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device
    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }
  volume_tags = merge(local.common-tags,each.value.tags)
}