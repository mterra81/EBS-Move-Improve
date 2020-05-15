############################################
# Create Compartment
############################################

resource "oci_identity_compartment" "ebs_hol_compartment" {
  name           = "ebs_hol_compartment"
  description    = "EBS HOL Compartment"
  compartment_id = "${var.tenancy_ocid}"
  enable_delete  = false                              // true will cause this compartment to be deleted when running `terrafrom destroy`
}

data "oci_identity_compartments" "ebs_hol_compartment" {
  compartment_id = "${oci_identity_compartment.ebs_hol_compartment.compartment_id}"

  filter {
    name   = "name"
    values = ["ebs_hol_compartment"]
  }
}

