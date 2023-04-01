#------------------
#リソース定義
#------------------
#------------------
# VPC 
#------------------
resource "aws_vpc" "rt_VPC" {
  cidr_block           = var.rt_cidr_block # v0.12 以降の書き方

  enable_dns_support               = "true" # VPC内でDNSによる名前解決を有効化するかを指定
  enable_dns_hostnames             = "true" # VPC内インスタンスがDNSホスト名を取得するかを指定
  instance_tenancy                 = "default" # VPC内インスタンスのテナント属性を指定
  assign_generated_ipv6_cidr_block = "false" # IPv6を有効化するかを指定

  tags = {
    Name = "rt-VPC-tf-${var.rt_env}"
    Env = var.rt_env
  }
}


#------------------
# Subnet
#------------------
# Public Subnet 1a
resource "aws_subnet" "rt_PubSubnet_1a" {
  vpc_id                          = aws_vpc.rt_VPC.id # VPCのIDを指定
  cidr_block                      = var.cb_pubsubnet_1a # サブネットに設定したいCIDRを指定
  assign_ipv6_address_on_creation = "false" # IPv6を利用するかどうかを指定
  map_public_ip_on_launch         = "true" # VPC内インスタンスにパブリックIPアドレスを付与するかを指定
  availability_zone               = var.az_main # サブネットが稼働するAZを指定

  tags = {
    Name = "rt-PubSubnet1a-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

# Private Subnet 1a
resource "aws_subnet" "rt_PrvSubnet_1a" {
  vpc_id                          = aws_vpc.rt_VPC.id # VPCのIDを指定
  cidr_block                      = var.cb_prvsubnet_1a # サブネットに設定したいCIDRを指定
  assign_ipv6_address_on_creation = "false" # IPv6を利用するかどうかを指定
  map_public_ip_on_launch = false # プライベートサブネットのためパブリックIPは不要
  availability_zone               = var.az_main # サブネットが稼働するAZを指定

  
  tags = {
    Name = "rt-PrvSubnet1a-tf-${var.rt_env}"
    Env = var.rt_env
  }
}


# Public Subnet 1c
resource "aws_subnet" "rt_PubSubnet_1c" {
  vpc_id                          = aws_vpc.rt_VPC.id # VPCのIDを指定
  cidr_block                      = var.cb_pubsubnet_1c # サブネットに設定したいCIDRを指定
  assign_ipv6_address_on_creation = "false" # IPv6を利用するかどうかを指定
  map_public_ip_on_launch         = "true" # VPC内インスタンスにパブリックIPアドレスを付与するかを指定
  availability_zone               = var.az_sub # サブネットが稼働するAZを指定

  tags = {
    Name = "rt-PubSubnet1c-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

# Private Subnet 1c
resource "aws_subnet" "rt_PrvSubnet_1c" {
  vpc_id                          = aws_vpc.rt_VPC.id # VPCのIDを指定
  cidr_block                      = var.cb_prvsubnet_1c # サブネットに設定したいCIDRを指定
  assign_ipv6_address_on_creation = "false" # IPv6を利用するかどうかを指定
  map_public_ip_on_launch = false # プライベートサブネットのためパブリックIPは不要
  availability_zone               = var.az_sub # サブネットが稼働するAZを指定
  
  tags = {
    Name = "rt-PrvSubnet1c-tf-${var.rt_env}"
    Env = var.rt_env
  }
}



#------------------
# Internet Gateway 
#------------------
resource "aws_internet_gateway" "rt_IGW" {
  vpc_id = aws_vpc.rt_VPC.id # VPCのIDを指定
  tags = {
    Name = "rt-IGW-tf-${var.rt_env}"
    Env = var.rt_env
  }
}


#------------------
# Route Table 
#------------------
resource "aws_route_table" "rt_PubRouteTable" {
  vpc_id = aws_vpc.rt_VPC.id # VPCのIDを指定

  # 外部向け通信を可能にするためのルート設定
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rt_IGW.id
  }

  tags = {
    Name = "rt-PubRouteTable-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

# 作成したRoute TableとVPCをひもづける 
#resource "aws_main_route_table_association" "rt_Route_VPC" {
#  vpc_id         = aws_vpc.rt_VPC.id # 紐づけたいVPCのIDを指定
#  route_table_id = aws_route_table.rt_PubRouteTable.id # 紐付けたいルートテーブルのIDを指定
#}

# 作成したRoute TableとPublice Subnet 1aをひもづける 
resource "aws_route_table_association" "rt_Route_PubSubet_1a" {
  route_table_id = aws_route_table.rt_PubRouteTable.id # 紐付けたいルートテーブルのIDを指定
  subnet_id      = aws_subnet.rt_PubSubnet_1a.id # 紐づけたいサブネットのIDを指定
}

# 作成したRoute TableとPublice Subnet 1cをひもづける 
resource "aws_route_table_association" "rt_Route_PubSubet_1c" {
  route_table_id = aws_route_table.rt_PubRouteTable.id # 紐付けたいルートテーブルのIDを指定
  subnet_id      = aws_subnet.rt_PubSubnet_1c.id # 紐づけたいサブネットのIDを指定
}


# Private Route Table
#resource "aws_eip" "rt_EIP" {
#  vpc        = true
#  depends_on = [aws_internet_gateway.rt_IGW]
#  
#  tags = {
#    Name = "rt-eip-tf-${var.rt_env}"
#    Env = var.rt_env
#  }
#}
#
#resource "aws_nat_gateway" "rt_NAT" {
#  allocation_id = aws_eip.rt_EIP.id
#  subnet_id     = aws_subnet.rt_PubSubnet_1a.id
#  depends_on    = [aws_internet_gateway.rt_IGW]
#  
#  tags = {
#    Name = "rt-nat-tf-${var.rt_env}"
#    Env = var.rt_env
#  }
#}
#
#resource "aws_route_table" "rt_PrvRouteTable" {
#  vpc_id = aws_vpc.rt_VPC.id # VPCのIDを指定
#
#  # 外部向け通信を可能にするためのルート設定
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.rt_NAT.id
#  }
#
#  tags = {
#    Name = "rt-PrvRouteTable-tf-${var.rt_env}"
#    Env = var.rt_env
#  }
#}
# 作成したRoute TableとPrivate Subnet 1aをひもづける 
#resource "aws_route_table_association" "rt_Route_PrvSubet_1a" {
#  route_table_id = aws_route_table.rt_PrvRouteTable.id # 紐付けたいルートテーブルのIDを指定
#  subnet_id      = aws_subnet.rt_PrvSubnet_1a.id # 紐づけたいサブネットのIDを指定
#}



#==================
# Output
#==================
#ターミナルへの出力・他ファイルからの参照
# 同じファイル内なら、 VPC ID は「 aws_vpc.tf_raisetech_vpc.id 」で参照ができる
output "VPC_id" {
  value = aws_vpc.rt_VPC.id
}

output "PublicSubnet1a_id" {
  value = aws_subnet.rt_PubSubnet_1a.id
}

output "PrivateSubnet1a_id" {
  value = aws_subnet.rt_PrvSubnet_1a.id
}

output "PublicSubnet1c_id" {
  value = aws_subnet.rt_PubSubnet_1c.id
}

output "PrivateSubnet1c_id" {
  value = aws_subnet.rt_PrvSubnet_1c.id
}

output "IGW_id" {
  value = aws_internet_gateway.rt_IGW.id
}

output "RouteTable_id" {
  value = aws_route_table.rt_PubRouteTable.id
}
