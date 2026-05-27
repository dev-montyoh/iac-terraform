# 기존 리소스 이름 변경 추적 (삭제/재생성 방지)
moved {
  from = oci_core_security_list.sl
  to   = oci_core_security_list.app_sl
}

moved {
  from = oci_core_subnet.subnet
  to   = oci_core_subnet.app_subnet
}

# VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.cidr_block]
  display_name   = var.vcn_name
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  enabled        = true
  display_name   = "${var.vcn_name}_IGW"
}

# Route Table
resource "oci_core_route_table" "rt" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}_RT"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# 애플리케이션 Security List (22, 80, 443)
resource "oci_core_security_list" "app_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}_APP_SL"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  dynamic "ingress_security_rules" {
    for_each = var.app_ingress_ports
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }
}

# 애플리케이션 Subnet
resource "oci_core_subnet" "app_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = var.app_subnet_cidr
  display_name      = "${var.vcn_name}_APP_SUBNET"
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.app_sl.id]
}

# 데이터베이스 Security List (22, 5432)
resource "oci_core_security_list" "db_sl" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_name}_DB_SL"

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  dynamic "ingress_security_rules" {
    for_each = var.db_ingress_ports
    content {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }
}

# 데이터베이스 Subnet
resource "oci_core_subnet" "db_subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.vcn.id
  cidr_block        = var.db_subnet_cidr
  display_name      = "${var.vcn_name}_DB_SUBNET"
  route_table_id    = oci_core_route_table.rt.id
  security_list_ids = [oci_core_security_list.db_sl.id]
}
