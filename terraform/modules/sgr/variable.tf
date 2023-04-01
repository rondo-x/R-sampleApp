#------------------
# 変数定義
#------------------

#------------------
# 環境変数定義
#------------------
variable "rt_env" {}

#------------------
# VPC
#------------------
variable "vpc_id" {}


#------------------
# Subnet
#------------------
variable "cb_pubsubnet_1a" {}

#------------------
# Security Group
#------------------
#variable "sg_ap_ingip" {
#  type = string
#  description = "AP Serverのセキュリティグループで許可するIngress用IP"
#  default = "0.0.0.0/0"
#}
