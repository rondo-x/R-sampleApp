# provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# backend
terraform {
  backend "s3" {
    bucket = "tf-raisetech-prj"
    key    = "rtenv/stage/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

#------------------
#変数定義
#------------------
# terraform.tfvarsから参照 
variable "rt_cidr_block" {}
variable "rt_env" {}

#------------------
# VPC
#------------------
# moduleの利用
module "rt_network" {
  # moduleの位置
  source = "../modules/network/"
  # 変数へ値の設定
  rt_cidr_block = var.rt_cidr_block
  rt_env        = var.rt_env

  cb_pubsubnet_1a = "10.0.10.0/24"
  cb_prvsubnet_1a = "10.0.11.0/24"
  cb_pubsubnet_1c = "10.0.20.0/24"
  cb_prvsubnet_1c = "10.0.21.0/24"

  az_main = "ap-northeast-1a"
  az_sub  = "ap-northeast-1c"
}


#------------------
# Security Group 
#------------------
module "rt_SecGr" {
  # moduleの位置
  source = "../modules/sgr/"
  # 変数へ値の設定
  rt_env = var.rt_env

  vpc_id          = module.rt_network.VPC_id
  cb_pubsubnet_1a = module.rt_network.PublicSubnet1a_id

}



#------------------
# ec2
#------------------
# Web Server
module "rt_webServer" {
  # moduleの位置
  source = "../modules/ec2/"
  # 変数へ値の設定
  rt_env = var.rt_env

  #  vpc_id          = module.rt_network.VPC_id
  #  sg_web_ingip    = "0.0.0.0/0"
  cb_pubsubnet_1a = module.rt_network.PublicSubnet1a_id

  rt_ec2type = "Web"
  sec_id     = module.rt_SecGr.rt_SecWebSvr_id
  
  ami        = "ami-0f36dcfcc94112ea1" # Amazon Linux2
  ins_type   = "t2.micro"
  prv_ipAddr = "10.0.10.10"
  key_name   = "aws-raisetech-ssh-key"
  dev_name   = "/dev/xvda"
  vol_type   = "gp2"
  vol_size   = "20"
}

# AP Server
module "rt_apServer" {
  # moduleの位置
  source = "../modules/ec2/"
  # 変数へ値の設定
  rt_env          = var.rt_env
  cb_pubsubnet_1a = module.rt_network.PublicSubnet1a_id

  rt_ec2type = "AP"
  sec_id     = module.rt_SecGr.rt_SecApSvr_id
  
  ami      = "ami-07200fa04af91f087" # Ubuntu
  ins_type = "t2.medium"
  prv_ipAddr = "10.0.10.50"
  key_name = "aws-raisetech-splApp"
  dev_name = "/dev/sda1"
  vol_type = "gp2"
  vol_size = "30"
}


#------------------
# RDS
#------------------
module "rt_apDB" {
  # moduleの位置
  source = "../modules/rds/"
  # 変数へ値の設定
  rt_env = var.rt_env

  cb_prvsubnet_1a = module.rt_network.PrivateSubnet1a_id
  cb_prvsubnet_1c = module.rt_network.PrivateSubnet1c_id
  sec_gr_id = module.rt_SecGr.rt_SecRDS_id

  # mstrUsrName = "input user name"
  # mstrUsrPW = "input password"
  ins_type = "db.t2.micro"
  vol_type = "gp2"
  alloc_strgSize = 30
}

#------------------
# ALB
#------------------
# Load Balancer 
module "rt_alb" {
  # moduleの位置
  source = "../modules/alb/"
  # 変数へ値の設定
  rt_env = var.rt_env

  vpc_id = module.rt_network.VPC_id
  sec_gr_id = module.rt_SecGr.rt_SecALB_id
  
  cb_pubsubnet_1a = module.rt_network.PublicSubnet1a_id
  cb_pubsubnet_1c = module.rt_network.PublicSubnet1c_id
  websvr_id = module.rt_webServer.rt_EC2_id

}