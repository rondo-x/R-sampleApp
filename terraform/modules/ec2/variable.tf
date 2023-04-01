#------------------
# 変数定義
#------------------

#------------------
# 環境変数定義
#------------------
variable "rt_env" {}

#------------------
# Subnet
#------------------
variable "cb_pubsubnet_1a" {}

#------------------
# EC2 Instance 
#------------------
variable "rt_ec2type" {
  type = string
  description = "Server種別: Web/AP"
}

variable "sec_id" {
#  type = string
  description = "関連づけるSecurity Group ID"
}

variable "ami" {
  type = string
  description = "作成するインスタンスのAMI"
}

variable "ins_type" {
  type = string
  description = "インスタンスタイプ"
  default = "t2.micro"
}

variable "prv_ipAddr" {
  type = string
  description = "private ip address"
}

variable "key_name" {
  type = string
  description = "aws-raisetech-ssh-key"
}

#ストレージ設定 
variable "dev_name" {
  type = string
  description = "ストレージのデバイス名"
}

variable "vol_type" {
  type = string
  description = "ストレージのデバイス名"
  default = "gp2"
}

variable "vol_size" {
  description = "ストレージのサイズ"
  default = 20
}

