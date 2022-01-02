variable "availability_zone_first" {
  default = "ap-guangzhou-3"
}

variable "availability_zone_second" {
  default = "ap-guangzhou-4"
}

variable "cluster_cidr" {
  default = "10.31.0.0/16"
}

variable "default_instance_type" {
  default = "SA2.2XLARGE16"
}

data "tencentcloud_vpc_subnets" "vpc_first" {
  is_default        = true
  availability_zone = var.availability_zone_first
}

data "tencentcloud_vpc_subnets" "vpc_second" {
  is_default        = true
  availability_zone = var.availability_zone_second
}

resource "tencentcloud_kubernetes_cluster" "managed_cluster" {
  vpc_id                                     = data.tencentcloud_vpc_subnets.vpc_first.instance_list.0.vpc_id
  cluster_cidr                               = var.cluster_cidr
  cluster_max_pod_num                        = 32
  cluster_name                               = "test"
  cluster_desc                               = "test cluster desc"
  cluster_max_service_num                    = 32
  cluster_internet                           = true
  managed_cluster_internet_security_policies = ["3.3.3.3", "1.1.1.1"]
  cluster_deploy_type                        = "MANAGED_CLUSTER"

  worker_config {
    count                      = 1
    availability_zone          = var.availability_zone_first
    instance_type              = var.default_instance_type
    system_disk_type           = "CLOUD_SSD"
    system_disk_size           = 60
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    internet_max_bandwidth_out = 100
    public_ip_assigned         = true
    subnet_id                  = data.tencentcloud_vpc_subnets.vpc_first.instance_list.0.subnet_id
    img_id                     = "img-rkiynh11"

    data_disk {
      disk_type = "CLOUD_PREMIUM"
      disk_size = 50
    }

    enhanced_security_service = false
    enhanced_monitor_service  = false
    user_data                 = "dGVzdA=="
    password                  = "ZZXXccvv1212"
  }

  worker_config {
    count                      = 1
    availability_zone          = var.availability_zone_second
    instance_type              = var.default_instance_type
    system_disk_type           = "CLOUD_SSD"
    system_disk_size           = 60
    internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
    internet_max_bandwidth_out = 100
    public_ip_assigned         = true
    subnet_id                  = data.tencentcloud_vpc_subnets.vpc_second.instance_list.0.subnet_id

    data_disk {
      disk_type = "CLOUD_PREMIUM"
      disk_size = 50
    }

    enhanced_security_service = false
    enhanced_monitor_service  = false
    user_data                 = "dGVzdA=="
    password                  = "ZZXXccvv1212"
    cam_role_name             = "CVM_QcsRole"
  }

  labels = {
    "test1" = "test1",
    "test2" = "test2",
  }
}
