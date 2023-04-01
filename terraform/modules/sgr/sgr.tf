#------------------
#リソース定義
#------------------

#------------------
# Security Group
#------------------
# Web Server
resource "aws_security_group" "rt_SecGr_EC2Web" {
  name        = "tf-rtSecGrWeb"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
#    security_groups = [aws_security_group.rt_SecGr_EC2Web.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rt-SecGrWeb-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

# AP Server 
resource "aws_security_group" "rt_SecGr_EC2AP" {
  name        = "tf-rtSecGrAP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
#    security_groups = [aws_security_group.rt_SecGr_EC2AP.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rt-SecGrAP-tf-${var.rt_env}"
    Env = var.rt_env
  }
}


# RDS 
resource "aws_security_group" "rt_SecGr_RDS" {
  name        = "tf-rtSecGrRDS"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rt-SecGrRDS-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

# ALB 
resource "aws_security_group" "rt_SecGr_ALB" {
  name        = "tf-rtSecGrALB"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "rt-SecGrALB-tf-${var.rt_env}"
    Env = var.rt_env
  }
}


#==================
# Output
#==================
#ターミナルへの出力・他ファイルからの参照
output "rt_SecWebSvr_id" {
  value = aws_security_group.rt_SecGr_EC2Web.id
}

output "rt_SecApSvr_id" {
  value = aws_security_group.rt_SecGr_EC2AP.id
}

output "rt_SecRDS_id" {
  value = aws_security_group.rt_SecGr_RDS.id
}

output "rt_SecALB_id" {
  value = aws_security_group.rt_SecGr_ALB.id
}
