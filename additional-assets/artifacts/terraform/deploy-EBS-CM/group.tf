############################################
# Create IAM Groups
############################################

resource "oci_identity_group" "ebs_cm_administrators_group" {
  name           = "ebs_cm_administrators_group"
  description    = "EBS Cloud Manager Administrators Group"
  compartment_id = "${var.tenancy_ocid}"
}


resource "oci_identity_group" "network_administrators_group" {
  name           = "network_administrators_group"
  description    = "Network Administrators Group"
  compartment_id = "${var.tenancy_ocid}"
}


resource "oci_identity_group" "ebs_hol_dbas_group" {
 name           = "ebs_hol_dbas_group"
  description    = "EBS HOL DBAs Group"
  compartment_id = "${var.tenancy_ocid}" 
}

############################################
# Create IAM Group Memberships for IAM Users
############################################


resource "oci_identity_user_group_membership" "ebs-cm-admin-cm-administrators-mem1" {
  compartment_id = "${var.tenancy_ocid}"
  user_id        = "${oci_identity_user.ebs-cm-admin.id}"
  group_id       = "${oci_identity_group.ebs_cm_administrators_group.id}"
}

resource "oci_identity_user_group_membership" "ebs-cm-admin-network-administrators-mem1" {
  compartment_id = "${var.tenancy_ocid}"
  user_id        = "${oci_identity_user.ebs-cm-admin.id}"
  group_id       = "${oci_identity_group.network_administrators_group.id}"
}


resource "oci_identity_user_group_membership" "ebs-cm-admin-ebs_hol_dbas_group-mem1" {
  compartment_id = "${var.tenancy_ocid}"
  user_id        = "${oci_identity_user.ebs-cm-admin.id}"
  group_id       = "${oci_identity_group.ebs_hol_dbas_group.id}"
}

