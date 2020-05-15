
output "Cloud_Manager_Admin_Username" {
  value = "${oci_identity_user.ebs-cm-admin.name}"
}

output "Compartment_OCID" {
  value = "${oci_identity_compartment.ebs_hol_compartment.id}"
}

output "VCN_OCID" {
  value = "${oci_core_virtual_network.ebs-hol-vcn.id}"
}

output "Region" {
  value = "${var.region}"
}

output "Tenancy_OCID" {
  value = "${var.tenancy_ocid}"
}

output "Cloud_Manager_Admin_User_OCID" {
  value = "${oci_identity_user.ebs-cm-admin.id}"
}

output "Cloud_Manager_Admin_Temporary_Password" {
  sensitive = false
  value     = "${oci_identity_ui_password.ebs-cm-admin-pwd.password}"
}

/* output "Internet_Gateway_OCID" {
  value = "${oci_core_internet_gateway.internet_gateway.id}"
}*/

/* output "Cloud_Manager_Security_List_OCID" {
  value = "${oci_core_security_list.ebs-cm-securitylist.id}"
}*/

//Add output for Fingerprint!!