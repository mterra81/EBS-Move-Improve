/* Network */
data "oci_identity_availability_domains" "availability_domains" {
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.compartment_id}"
}

############################################
# Local variables
############################################

locals {
  tcp_protocol = "6"
  icmp_protocol = "1"
  all_protocol = "all"
  anywhere = "0.0.0.0/0"
  vcn_cidr = "10.0.0.0/16"
  ebs_cm_cidr = "10.0.1.0/24"
  ebscm_lb_cidr = "10.0.2.0/24"
}

############################################
# Create VCN
############################################

resource "oci_core_virtual_network" "ebs-hol-vcn" {
  display_name = "EBS Cloud Manager HOL VCN"
  cidr_block = "${local.vcn_cidr}"
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.id}"
  dns_label = "lbnetworkvcn"
}

############################################
# Create Internet Gateway
############################################

resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.id}"
  display_name = "Internet Gateway"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"
}

############################################
# Create Route Table
############################################

resource "oci_core_route_table" "lb-routetable" {
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.id}"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"
  display_name = "LB Route Table (Public)"

  route_rules {
    destination = "${local.anywhere}"
//    destination_type = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}

resource "oci_core_route_table" "ebs-cm-routetable" {
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.id}"
  vcn_id         = "${oci_core_virtual_network.ebs-hol-vcn.id}"
  display_name = "EBS CM Route Table"

  route_rules {
    destination       = "${local.anywhere}"
//    destination_type  = "CIDR_BLOCK"
    network_entity_id = "${oci_core_internet_gateway.internet_gateway.id}"
  }
}

############################################
# Create Security List
############################################

resource "oci_core_security_list" "lb-securitylist" {
  display_name = "LB Security List (public subnets)"
  compartment_id = "${oci_core_virtual_network.ebs-hol-vcn.compartment_id}"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"

    egress_security_rules = [
    {
      protocol = "${local.all_protocol}"
      destination = "${local.anywhere}"
    }]

    ingress_security_rules = [
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
  ]
}

resource "oci_core_security_list" "ebs-cm-securitylist" {
  display_name = "EBS CM Security List"
  compartment_id = "${oci_core_virtual_network.ebs-hol-vcn.compartment_id}"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"

  egress_security_rules = [
    {
      protocol = "${local.all_protocol}"
      destination = "${local.anywhere}"
    }]

  ingress_security_rules = [
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 22
        "max" = 22
      }
    },
    {
      protocol = "${local.icmp_protocol}"
      source = "${local.anywhere}"

      icmp_options {
        "type" = 3
        "code" = 4
      }
    },
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.ebscm_lb_cidr}"

      tcp_options {
        "min" = 8081
        "max" = 8081
      }
    },
  ]
}

############################################
# Create Load Balancer Regional Subnet
############################################
resource "oci_core_subnet" "ebs-cm-lb-subnet" {
  display_name = "EBS CM Load Balancer Subnet"
  cidr_block = "${local.ebscm_lb_cidr}"
  dns_label = "lbsubnet1"
  security_list_ids = ["${oci_core_security_list.lb-securitylist.id}"]
  compartment_id = "${oci_core_virtual_network.ebs-hol-vcn.compartment_id}"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"
  route_table_id = "${oci_core_route_table.lb-routetable.id}"
  dhcp_options_id = "${oci_core_virtual_network.ebs-hol-vcn.default_dhcp_options_id}"

  provisioner "local-exec" {
    command = "sleep 5"
  }
}

############################################
# Create EBS Cloud Manager Subnet
############################################
resource "oci_core_subnet" "ebs-cm-subnet" {
  display_name = "EBS Cloud Manager Subnet"
//  availability_domain = "${lookup(data.oci_identity_availability_domains.availability_domains.availability_domains[0],"name")}"
  cidr_block = "${local.ebs_cm_cidr}"
  dns_label = "lbsubnet3"
  compartment_id = "${oci_core_virtual_network.ebs-hol-vcn.compartment_id}"
  vcn_id = "${oci_core_virtual_network.ebs-hol-vcn.id}"
  security_list_ids = ["${oci_core_security_list.ebs-cm-securitylist.id}"]
  route_table_id = "${oci_core_route_table.ebs-cm-routetable.id}"
  dhcp_options_id = "${oci_core_virtual_network.ebs-hol-vcn.default_dhcp_options_id}"
//  prohibit_public_ip_on_vnic = "true"
}
