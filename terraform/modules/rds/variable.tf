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
variable "cb_prvsubnet_1a" {}
variable "cb_prvsubnet_1c" {}

#------------------
# RDS Instance 
#------------------
variable "sec_gr_id" {}
#variable "subnet_gr_name" {}
#variable "parame_gr_name" {}
#variable "opt_gr_name" {}


variable "mstrUsrName" {
  type = string
  description = "Master User Name"
  default = "root"
}

variable "mstrUsrPW" {
  type = string
  description = "Master User Password"
  default = "UmZHJ7AERwb4"
}

variable "ins_type" {
  type = string
  description = "インスタンスタイプ"
  default = "db.t2.micro"
}

variable "vol_type" {
  type = string
  description = "ストレージのデバイス名"
  default = "gp2"
}

variable "alloc_strgSize" {
  description = "Master User Name"
  default = 20
}
