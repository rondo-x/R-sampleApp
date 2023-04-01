#------------------
# Target Group
#------------------
resource "aws_lb_target_group" "rt_TargetGr_ALB" {
  name        = "rt-targetgr-tf-${var.rt_env}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    interval = 10
    path        = "/"
    port = 80
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
    matcher = 200
  }
}

# ターゲットグループをインスタンスに紐づける
resource "aws_lb_target_group_attachment" "rt_TargetGr_ALB" {
  target_group_arn = aws_lb_target_group.rt_TargetGr_ALB.arn
  target_id        = var.websvr_id
  port             = 80
}


#------------------
# Listner
#------------------
resource "aws_alb_listener" "rt_ListnerALB" {
  load_balancer_arn = "${aws_alb.rt_ALB.arn}"
  port              = "80"
  protocol          = "HTTP"
#  ssl_policy        = "ELBSecurityPolicy-2015-05"
#  certificate_arn   = "${var.alb_config["certificate_arn"]}"

  default_action {
    target_group_arn = "${aws_lb_target_group.rt_TargetGr_ALB.arn}"
    type             = "forward"
  }
}



#------------------
# Load Balancing 
#------------------
resource "aws_alb" "rt_ALB" {
  name        = "rt-alb-tf-${var.rt_env}"
  security_groups            = [var.sec_gr_id]
#  subnets                    = ["${aws_subnet.frontend_subnet.*.id}"]
  subnets = [var.cb_pubsubnet_1a, var.cb_pubsubnet_1c]
  
  internal                   = false
  enable_deletion_protection = false

#  access_logs {
#    bucket = "${aws_s3_bucket.alb_log.bucket}"
#  }
  
  tags = {
    Name = "rt-ALB-${var.rt_env}"
    Env = var.rt_env
  }
}

#==================
# Output
#==================
#ターミナルへの出力・他ファイルからの参照
output "rt_ALB_id" {
  value = aws_alb.rt_ALB.id
}
