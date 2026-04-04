resource "aws_instance" "this" {
  count                       = length(var.instances)
  ami                         = var.instances[count.index].ami
  instance_type               = var.instances[count.index].instance_type
  availability_zone           = var.instances[count.index].availability_zone
  subnet_id                   = var.instances[count.index].subnet_id
  private_ip                  = var.instances[count.index].private_ip
  associate_public_ip_address = var.instances[count.index].associate_public_ip_address

  tags = var.instances[count.index].tags

  root_block_device {
    delete_on_termination = true
    encrypted             = var.enable_root_block_device_encryption
    kms_key_id            = var.enable_root_block_device_encryption ? var.kms_key_id : null
  }

  lifecycle {
    ignore_changes = [ebs_block_device]
  }
}

locals {
  ebs_devices = flatten([
    for i, instance in var.instances : [
      for j, ebs in instance.ebs_block_device : {
        instance_index = i
        instance_name  = instance.name
        device_name    = ebs.device_name
        volume_size    = ebs.volume_size
        az             = instance.availability_zone
      }
    ]
  ])
}

resource "aws_ebs_volume" "this" {
  count             = length(local.ebs_devices)
  availability_zone = local.ebs_devices[count.index].az
  size              = local.ebs_devices[count.index].volume_size
  encrypted         = var.enable_ebs_encryption
  kms_key_id        = var.enable_ebs_encryption ? var.kms_key_id : null

  tags = {
    Name = "EBS volume for ${local.ebs_devices[count.index].instance_name}"
  }
}

resource "aws_volume_attachment" "this" {
  count       = length(local.ebs_devices)
  device_name = local.ebs_devices[count.index].device_name
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = aws_instance.this[local.ebs_devices[count.index].instance_index].id
}
