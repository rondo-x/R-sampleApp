#------------------
# Subnet Group
#------------------
resource "aws_db_subnet_group" "rt_SubnetGr_mysql" {
  name = "rt-subnetgr-mysql-tf-${var.rt_env}"
  # subnetの設定
  subnet_ids = [
    # subnetの設定 
    var.cb_prvsubnet_1a, var.cb_prvsubnet_1c
  ]

  tags = {
    Name = "rt-SubnetGrMySQL-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

#------------------
# Parameter Group
#------------------
resource "aws_db_parameter_group" "rt_PrmGr_mysql" {
  name = "rt-prmgr-mysql-tf-${var.rt_env}"
  family = "mysql8.0"
}

#------------------
# Option Group
#------------------
resource "aws_db_option_group" "rt_OptGr_MySQL" {
  name = "rt-optgr-mysql-tf-${var.rt_env}"
  engine_name = "mysql"
  major_engine_version = "8.0"
}

#------------------
# RDS 
#------------------
#resource "random_string" "db_passwrod" {
#  length = 16
#  special = false
#}

# DBの作成(前回の作成時間：8m10s、削除時間：3m55s)
resource "aws_db_instance" "rt_MySQL" {
  # 使用するDBを設定
  engine = "mysql"
  # 使用するDBのバージョンを設定
  engine_version = "8.0"

  # dbの名前（任意）
  identifier = "rt-ap-${var.rt_env}"
  # dbユーザー名
  username = var.mstrUsrName
  # パスワード。上記で生成したランダムな文字列を設定
  password = var.mstrUsrPW

  # インスタンスクラスの設定
  instance_class = var.ins_type

  # ストレージの大きさ。デフォルトのサイズ（GB）を設定
  allocated_storage = var.alloc_strgSize
  # ストレージの自動拡張サイズ（GB）を設定
  #max_allocated_storage = 50
  # ストレージタイプ。デフォルトはgp2
  storage_type = var.vol_type
  # ストレージの暗号化を行うかどうか設定
  storage_encrypted = false


  # マルチAZの設定を行うかどうか設定する
  multi_az = false

  # マルチAZを行わない場合は、DBの配置先を指定する
  availability_zone = "ap-northeast-1a"

  # サブネットグループを設定する(上記で作成したもの)
  db_subnet_group_name = aws_db_subnet_group.rt_SubnetGr_mysql.name

  # セキュリティグループの設定をする(01_networkのoutputs.tfの情報を利用)
#  vpc_security_group_ids = [ data.terraform_remote_state.network.outputs.aws_security_group_db_id 
  vpc_security_group_ids = [var.sec_gr_id]

  # publicアクセスを許可するか設定
  publicly_accessible = false

  # ポート番号を設定
  port = 3306

  # データベース名を設定
  #name = "labDB"
  # パラメーターグループ名を設定（上記で作成したもの）
  parameter_group_name = aws_db_parameter_group.rt_PrmGr_mysql.name

  # オプショングループ名を設定（上記で作成したもの）
  option_group_name = aws_db_option_group.rt_OptGr_MySQL.name


  # -- DBの管理設定。maintenance_windowは、backup_windowの後の時間に設定する
  # バックアップを行う時間を設定
  #backup_window = "04:00-05:00"
  # バックアップの保存期間（日）を設定
  backup_retention_period = 0 # 自動バックアップなし 

  # DBインスタンスまたはクラスターのエンジンバージョンの更新、OS更新があった場合に更新作業を行う時間を設定
  maintenance_window = "Mon:05:00-Mon:08:00"

  # 自動的にDBのマイナーバージョンアップグレードを行うか設定する
  auto_minor_version_upgrade = true

  # 削除設定
  # 削除操作を受付 
  deletion_protection = false # 削除する
  # インスタンス削除時にスナップショットをとるかを設定
  skip_final_snapshot = true # 取得しない
  # DBインスタンスが削除されたときに保存するスナップショットの名前 skip_final_snapshot = falseの時に指定
  #final_snapshot_identifier = "final-snapshot"
  
  # データベースの変更をすぐに適用するか、次のメンテナンスウィンドウ中に適用するかを指定する
  apply_immediately = true


  tags = {
    Name = "rt-MySQL-tf-${var.rt_env}"
    Env = var.rt_env
  }
}

#==================
# Output
#==================
#ターミナルへの出力・他ファイルからの参照
output "rt_DB_name" {
  value = aws_db_instance.rt_MySQL.name
}

output "rt_DB_id" {
  value = aws_db_instance.rt_MySQL.id
}
