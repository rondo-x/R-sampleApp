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
variable "cb_pubsubnet_1c" {}

#------------------
# EC2
#------------------
variable "websvr_id" {}

#------------------
# ALB 
#------------------
variable "sec_gr_id" {
#  type = string
  description = "関連づけるSecurity Group ID"
}

