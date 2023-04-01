#------------------
#リソース定義
#------------------

resource "aws_instance" "rt_EC2" {
  count         = 1
  ami           = var.ami
  instance_type = var.ins_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.sec_id]
#    ["${aws_security_group.rt_SecGr_EC2Web.id}"]

#  subnet_id                   = element(var.subnets.*.id, count.index % length(var.subnets))
   subnet_id = var.cb_pubsubnet_1a
   associate_public_ip_address = "true"
   private_ip = var.prv_ipAddr

  ebs_block_device {
    device_name = var.dev_name
    volume_type = var.vol_type
    volume_size = var.vol_size
  }

  tags = {
    Name = "rt-EC2${var.rt_ec2type}-${var.rt_env}"
    Env = var.rt_env
  }
}


#==================
# Output
#==================
#ターミナルへの出力・他ファイルからの参照
output "rt_EC2_name" {
  value = aws_instance.rt_EC2[0].key_name
}

output "rt_EC2_id" {
  value = aws_instance.rt_EC2[0].id
}
