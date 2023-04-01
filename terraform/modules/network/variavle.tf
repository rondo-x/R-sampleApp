#------------------
# 変数定義
#------------------

#------------------
# 環境変数定義
#------------------
variable "rt_env" {
  type = string
  description = "prod / stage"
  default = "stage"
}

#------------------
# VPC
#------------------
variable "rt_cidr_block" {
  type = string
  description = "VPCのCIDR"
  default = "10.0.0.0/16"
}

#------------------
# Subnet
#------------------
variable "cb_pubsubnet_1a" {
  type = string
  description = "Public Subnet 1a のCIDR"
  default = "10.0.10.0/24"
}

variable "cb_prvsubnet_1a" {
  type = string
  description = "Private Subnet 1a のCIDR"
  default = "10.0.11.0/24"
}

variable "cb_pubsubnet_1c" {
  type = string
  description = "Public Subnet 1c のCIDR"
  default = "10.0.20.0/24"
}

variable "cb_prvsubnet_1c" {
  type = string
  description = "Private Subnet 1c のCIDR"
  default = "10.0.21.0/24"
}


variable "az_main" {
  type = string
  description = "MainのAvailability Zoon"
  default = "ap-northeast-1a"
}

variable "az_sub" {
  type = string
  description = "SubのAvailability Zoon"
  default = "ap-northeast-1c"
}



